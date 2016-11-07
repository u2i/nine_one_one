require 'spec_helper'

describe NineOneOne do
  it 'has a version number' do
    expect(NineOneOne::VERSION).not_to be nil
  end

  before { NineOneOne.instance_variable_set(:@config, nil) }

  describe '.service' do
    before do
      NineOneOne.configure do |config|
        config.send_pagers = send_pagers
        config.pager_duty_integration_key = pager_key
        config.logger = logger
      end
    end

    context 'when send_pagers is true' do
      let(:send_pagers) { true }
      let(:pager_key) { 'pager-key-123' }
      let(:logger) { nil }

      it 'returns PagerDutyService' do
        expect(NineOneOne.service).to be_a NineOneOne::PagerDutyService
      end
    end

    context 'when send_pagers is false' do
      let(:send_pagers) { false }
      let(:pager_key) { nil }
      let(:logger) { double('Logger', error: 'error!') }

      it 'returns LogService' do
        expect(NineOneOne.service).to be_a NineOneOne::LogService
      end
    end
  end

  describe 'configuration' do
    it 'raises error when has not been configured' do
      expect { NineOneOne.config }.to raise_error(NineOneOne::ConfigurationError)
    end

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

    context 'when send_pagers is false' do
      it 'expects logger to be present' do
        expect do
          NineOneOne.configure do |config|
            config.send_pagers = false
          end
        end.to raise_error(NineOneOne::ConfigurationError)
      end

      it 'expects logger to have #error method' do
        not_really_a_logger = double

        expect do
          NineOneOne.configure do |config|
            config.send_pagers = false
            config.logger = not_really_a_logger
          end
        end.to raise_error(NineOneOne::ConfigurationError)
      end
    end
  end
end
