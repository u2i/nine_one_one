require 'spec_helper'

describe NineOneOne::Notifier do
  subject(:notifier) { described_class.new(config) }
  let(:config) { NineOneOne::Configuration.new }

  describe '.emergency_service' do
    context 'when send_pagers is true' do
      let(:config) do
        NineOneOne::Configuration.new.tap do |config|
          config.send_pagers = true
          config.pager_duty_integration_key = 'pager-key-123'
        end
      end

      it 'returns PagerDutyService' do
        expect(notifier.emergency_service).to be_a NineOneOne::PagerDutyService
      end
    end

    context 'when send_pagers is false' do
      let(:send_pagers) { false }
      let(:pager_key) { nil }
      let(:logger) { double('Logger', info: 'info', error: 'error') }

      it 'returns LogService' do
        expect(notifier.emergency_service).to be_a NineOneOne::LogService
      end
    end
  end

  describe '.notification_service' do
    let(:logger) { double('Logger', error: 'error!', info: 'info!') }
    let(:slack_webhook_url) { 'url' }

    let(:config) do
      NineOneOne::Configuration.new.tap do |config|
        config.slack_enabled = slack_enabled
        config.slack_webhook_url = slack_webhook_url
        config.logger = logger
      end
    end

    context 'when slack is not enabled' do
      let(:slack_enabled) { false }

      it 'returns logging service' do
        expect(notifier.notification_service).to be_a(NineOneOne::LogService)
      end
    end

    context 'when slack is enabled' do
      let(:slack_enabled) { true }

      it 'returns slack service' do
        expect(notifier.notification_service).to be_a(NineOneOne::SlackService)
      end
    end
  end
end
