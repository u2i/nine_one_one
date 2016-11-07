require 'spec_helper'

describe NineOneOne::PagerDutyService do
  describe '#trigger_event' do
    let(:api_integration_token) { 'PAGER_DUTY_API_INTEGRATION_TOKEN' }

    subject { NineOneOne::PagerDutyService.new(api_integration_token) }

    describe 'when API call succeeds' do
      use_vcr_cassette 'pager_duty_trigger_event_success', match_requests_on: [:body]

      it 'calls pager duty service with proper json' do
        subject.trigger_event('INCIDENT_KEY', 'Incident description')
      end
    end

    describe 'when call to API fails' do
      use_vcr_cassette 'pager_duty_trigger_event_failure', match_requests_on: [:body]

      it 'raises an error' do
        expect { subject.trigger_event('INCIDENT_KEY', 'Description') }
          .to raise_error(NineOneOne::Errors::IncidentReportingError)
      end
    end
  end
end
