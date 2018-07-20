require 'spec_helper'

describe NineOneOne do
  it 'has a version number' do
    expect(NineOneOne::VERSION).not_to be nil
  end

  describe 'configuration' do
    it 'accepts "send_pagers" param' do
      NineOneOne.configure do |config|
        config.send_pagers = true
        config.pager_duty_integration_key = 'key-123'
      end

      expect(NineOneOne.configs[:default].send_pagers).to eq true
    end

    it 'raises error when send_pagers is nil' do
      expect do
        NineOneOne.configure do |config|
          config.send_pagers = nil
          config.pager_duty_integration_key = 'key-123'
        end
      end.to raise_error(NineOneOne::ConfigurationError)
    end

    it 'raises error when send_pagers is neither true nor false' do
      expect do
        NineOneOne.configure do |config|
          config.send_pagers = '123'
          config.pager_duty_integration_key = 'key-123'
        end
      end.to raise_error(NineOneOne::ConfigurationError)
    end

    it 'expects logger to have #error method' do
      not_really_a_logger = double

      allow(not_really_a_logger).to receive(:info)

      expect do
        NineOneOne.configure do |config|
          config.send_pagers = false
          config.logger = not_really_a_logger
        end
      end.to raise_error(NineOneOne::ConfigurationError)
    end

    it 'expects logger to have #info method' do
      not_really_a_logger = double

      allow(not_really_a_logger).to receive(:error)

      expect do
        NineOneOne.configure do |config|
          config.send_pagers = false
          config.logger = not_really_a_logger
        end
      end.to raise_error(NineOneOne::ConfigurationError)
    end

    context 'when send_pagers is true' do
      it 'accepts "pager_duty_integration_key" param' do
        NineOneOne.configure do |config|
          config.send_pagers = true
          config.pager_duty_integration_key = 'pager-key-123'
        end

        expect(NineOneOne.configs[:default].pager_duty_integration_key).to eq 'pager-key-123'
      end

      it 'raises error if "pager_duty_integration_key" is null but send_pagers is true' do
        expect do
          NineOneOne.configure do |config|
            config.send_pagers = true
          end
        end.to raise_error(NineOneOne::ConfigurationError)
      end

      it 'raises error if "pager_duty_integration_key" is null but send_pagers is blank' do
        expect do
          NineOneOne.configure do |config|
            config.send_pagers = true
            config.pager_duty_integration_key = ''
          end
        end.to raise_error(NineOneOne::ConfigurationError)
      end
    end

    context 'when slack is enabled' do
      let(:slack_enabled) { true }

      it 'raises error if slack webhook url is not set' do
        expect do
          NineOneOne.configure do |config|
            config.slack_enabled = slack_enabled
          end
        end.to raise_error(NineOneOne::ConfigurationError)
      end
    end

    context 'with multi config' do
      before do
        NineOneOne.configure(:urgent) do |config|
          config.slack_enabled = false
        end

        NineOneOne.configure(:non_urgent) do |config|
          config.slack_webhook_url = 'webhook'
          config.slack_channel = 'channel'
          config.slack_enabled = true
        end
      end

      it 'has separate settings for each configuration' do
        expect(NineOneOne.configs[:default].slack_enabled).to eq(false)
        expect(NineOneOne.configs[:urgent].slack_enabled).to eq(false)
        expect(NineOneOne.configs[:non_urgent].slack_enabled).to eq(true)
      end

      it 'raises error when non-existent configuration is requested' do
        expect { NineOneOne.use(:foo) }.to raise_error(NineOneOne::NotConfiguredError)
      end
    end
  end

  describe '.use' do
    context 'with default config' do
      it 'returns preconfigured notifier' do
        NineOneOne.configure do |config|
          config.send_pagers = true
          config.pager_duty_integration_key = 'integration key'
          config.slack_enabled = true
          config.slack_channel = 'channel'
          config.slack_webhook_url = 'http://example.com'
        end

        notifier = NineOneOne.use(:default)

        expect(notifier.notification_service).to be_an_instance_of(NineOneOne::SlackService)
        expect(notifier.emergency_service).to be_an_instance_of(NineOneOne::PagerDutyService)
      end
    end

    context 'custom config' do
      it 'returns preconfigured notifier' do
        NineOneOne.configure(:my_custom_config) do |config|
          config.send_pagers = true
          config.pager_duty_integration_key = 'integration key'
          config.slack_enabled = true
          config.slack_channel = 'channel'
          config.slack_webhook_url = 'http://example.com'
        end

        notifier = NineOneOne.use(:my_custom_config)

        expect(notifier.notification_service).to be_an_instance_of(NineOneOne::SlackService)
        expect(notifier.emergency_service).to be_an_instance_of(NineOneOne::PagerDutyService)
      end
    end
  end

  describe '.emergency' do
    let(:notifier) { spy(NineOneOne::Notifier) }
    let(:source) { 'error source info' }
    let(:message) { 'danger' }
    let(:details_hash) { { why: 'I dont know' } }
    let(:severity) { NineOneOne::PagerDutyService::HIGH_URGENCY_ERROR }
    let(:dedup_key) { 'dedup_key' }

    it 'delegates sending to notifier' do
      allow(NineOneOne).to receive(:use).and_return(notifier)
      NineOneOne.emergency(message, source, details_hash: details_hash, severity: severity,
                                            dedup_key: dedup_key)
      expect(notifier).to have_received(:emergency).with(message, source, details_hash: details_hash,
                                                                          severity: severity, dedup_key: dedup_key)
    end
  end

  describe '.notify' do
    let(:notifier) { spy(NineOneOne::Notifier) }
    let(:message) { 'alert' }

    it 'delegates notification to notifier' do
      allow(NineOneOne).to receive(:use).with(:default).and_return(notifier)
      NineOneOne.notify(message)
      expect(notifier).to have_received(:notify).with(message)
    end
  end

  describe '.notification_service' do
    let(:notifier) { spy(NineOneOne::Notifier) }

    it 'returns default notification service' do
      allow(NineOneOne).to receive(:use).with(:default).and_return(notifier)
      NineOneOne.notification_service

      expect(notifier).to have_received(:notification_service)
    end
  end

  describe '.emergency_service' do
    let(:notifier) { spy(NineOneOne::Notifier) }

    it 'returns default emergency service' do
      allow(NineOneOne).to receive(:use).with(:default).and_return(notifier)
      NineOneOne.emergency_service

      expect(notifier).to have_received(:emergency_service)
    end
  end
end
