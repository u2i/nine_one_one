require 'spec_helper'

describe NineOneOne::PagerDutyService do
  describe '#trigger_event' do
    let(:details_hash) { {backtrace: 'log'} }
    subject(:pager_service) { NineOneOne::PagerDutyService.new('PAGER_DUTY_API_INTEGRATION_TOKEN') }

    describe 'when API call succeeds' do
      use_vcr_cassette 'pager_duty_trigger_event_success', match_requests_on: [:body]

      it 'calls pager duty service with proper json' do
        pager_service.trigger_event('Incident description', 'source info', details_hash, 'error')
      end
    end

    describe 'when call to API fails' do
      use_vcr_cassette 'pager_duty_trigger_event_failure', match_requests_on: [:body]

      it 'raises an error' do
        expect { pager_service.trigger_event('Incident description', nil) }
          .to raise_error(NineOneOne::IncidentReportingError)
      end
    end
  end
end
