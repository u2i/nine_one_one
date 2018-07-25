require 'spec_helper'

describe NineOneOne::PagerDutyService do
  describe '#trigger_event' do
    let(:message) { 'Incident description' }
    let(:source) { 'source info' }
    let(:details_hash) { {backtrace: 'log'} }
    let(:severity) { NineOneOne::PagerDutyService::HIGH_URGENCY_ERROR }

    subject(:pager_service) { NineOneOne::PagerDutyService.new('PAGER_DUTY_API_INTEGRATION_TOKEN') }

    describe 'when API call succeeds' do
      use_vcr_cassette 'pager_duty_trigger_event_success', match_requests_on: [:body]

      it 'calls pager duty service with proper json' do
        pager_service.trigger_event('Incident description', source: 'source info', details_hash: details_hash, severity: severity)
      end
    end

    describe 'when call to API fails' do
      use_vcr_cassette 'pager_duty_trigger_event_failure', match_requests_on: [:body]

      it 'raises an error' do
        expect { pager_service.trigger_event('Incident description', source: nil, details_hash: {}, severity: severity) }
          .to raise_error(NineOneOne::IncidentReportingError)
      end
    end
  end
end
