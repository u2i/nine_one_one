require 'spec_helper'

describe NineOneOne::SlackService do
  let(:webhook_url) { 'https://hooks.slack.com/services/XXX' }

  describe 'vcr test' do
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

  describe 'using optional fields' do
    let(:http) { instance_double(NineOneOne::Http) }

    subject { described_class.new(webhook_url, opts) }

    before { expect(http).to receive(:post).with('/services/XXX', expected_body, Hash) }

    describe 'with one optional field' do
      let(:opts) { { http: http, username: 'NineOneOne' } }

      let(:expected_body) { { text: 'message', username: 'NineOneOne' }.to_json }

      it 'sends proper JSON' do
        subject.notify('message')
      end
    end

    describe 'with all optional fields' do
      let(:opts) { { http: http, username: 'NineOneOne', channel: '#my-chan' } }

      let(:expected_body) { { text: 'message', channel: '#my-chan', username: 'NineOneOne' }.to_json }

      it 'sends proper JSON' do
        subject.notify('message')
      end
    end
  end
end
