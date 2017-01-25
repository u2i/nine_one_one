require 'spec_helper'

describe NineOneOne do
  it 'has a version number' do
    expect(NineOneOne::VERSION).not_to be nil
  end

  before { NineOneOne.instance_variable_set(:@config, nil) }

  describe 'default config' do
    it 'is valid' do
      config = NineOneOne.config

      expect { config.validate }.not_to raise_error
    end
  end

  describe '.emergency_service' do
    context 'when send_pagers is true' do
      let(:send_pagers) { true }
      let(:pager_key) { 'pager-key-123' }

      it 'returns PagerDutyService' do
        NineOneOne.configure do |config|
          config.send_pagers = send_pagers
          config.pager_duty_integration_key = pager_key
        end

        expect(NineOneOne.emergency_service).to be_a NineOneOne::PagerDutyService
      end
    end

    context 'when send_pagers is false' do
      let(:send_pagers) { false }
      let(:pager_key) { nil }
      let(:logger) { double('Logger', info: 'info', error: 'error') }

      it 'returns LogService' do
        NineOneOne.configure do |config|
          config.send_pagers = send_pagers
          config.pager_duty_integration_key = pager_key
          config.logger = logger
        end

        expect(NineOneOne.emergency_service).to be_a NineOneOne::LogService
      end
    end
  end

  describe '.notification_service' do
    let(:logger) { double('Logger', error: 'error!', info: 'info!') }
    let(:webhook_url) { 'url' }

    subject { described_class.notification_service }

    before do
      NineOneOne.configure do |config|
        config.slack_enabled = slack_enabled
        config.webhook_url = webhook_url
        config.logger = logger
      end
    end

    context 'when slack is not enabled' do
      let(:slack_enabled) { false }

      it 'returns logging service' do
        expect(subject).to be_a(NineOneOne::LogService)
      end
    end

    context 'when slack is enabled' do
      let(:slack_enabled) { true }

      it 'returns slack service' do
        expect(subject).to be_a(NineOneOne::SlackService)
      end
    end
  end

  describe 'configuration' do
    it 'accepts "send_pagers" param' do
      NineOneOne.configure do |config|
        config.send_pagers = true
        config.pager_duty_integration_key = 'key-123'
      end

      expect(NineOneOne.config.send_pagers).to eq true
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

        expect(NineOneOne.config.pager_duty_integration_key).to eq 'pager-key-123'
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

      it 'raises error if webhook url is not set' do
        expect do
          NineOneOne.configure do |config|
            config.slack_enabled = slack_enabled
          end
        end.to raise_error(NineOneOne::ConfigurationError)
      end
    end
  end

  describe '.emergency' do
    let(:emergency_service) { instance_double(NineOneOne::PagerDutyService) }
    let(:incident_key) { 'ERROR_KEY' }
    let(:message) { 'danger' }
    let(:details_hash) { { why: 'I dont know' } }

    it 'delegates sending to emergency service' do
      allow(NineOneOne).to receive(:emergency_service).and_return(emergency_service)

      expect(emergency_service).to receive(:trigger_event).with(incident_key, message, details_hash)

      NineOneOne.emergency(incident_key, message, details_hash)
    end
  end

  describe '.notify' do
    let(:notification_service) { instance_double(NineOneOne::SlackService) }
    let(:message) { 'alert' }

    it 'delegates notification to notification service' do
      allow(NineOneOne).to receive(:notification_service).and_return(notification_service)

      expect(notification_service).to receive(:notify).with(message)

      NineOneOne.notify(message)
    end
  end
end
