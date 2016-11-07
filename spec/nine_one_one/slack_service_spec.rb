require 'spec_helper'

describe NineOneOne::SlackService do
  describe '#notify' do
    let(:webhook_url) { 'https://hooks.slack.com/services/XXX' }

    subject { described_class.new(webhook_url) }

    describe 'when API call succeeds' do
      use_vcr_cassette 'slack_notification_success', match_requests_on: [:body]

      it 'calls slack service with message' do
        expect(subject.notify('message')).to eq true
      end
    end

    describe 'when call to API fails' do
      use_vcr_cassette 'slack_notification_failure'

      it 'returns false' do
        expect(subject.notify('message')).to eq false
      end
    end
  end
end
