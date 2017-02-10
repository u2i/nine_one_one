require 'spec_helper'

describe NineOneOne::SlackService do
  let(:webhook_url) { 'https://hooks.slack.com/services/XXX' }

  describe 'with no optional fields' do
    subject { described_class.new(webhook_url) }

    describe 'when API call succeeds' do
      use_vcr_cassette 'slack_notification_success'

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

  describe 'with optional fields' do
    subject { described_class.new(webhook_url, opts) }

    context 'with one optional field' do
      use_vcr_cassette 'slack_notification_with_username'

      let(:opts) { { username: 'NineOneOne' } }

      let(:expected_body) { { text: 'message', username: 'NineOneOne' }.to_json }

      it 'sends proper JSON' do
        expect(subject.notify('message')).to eq true
      end
    end

    context 'with all optional fields' do
      use_vcr_cassette 'slack_notification_all_fields'

      let(:opts) { { username: 'NineOneOne', channel: '#ruby-rails' } }

      let(:expected_body) { { text: 'message', channel: '#ruby-rails', username: 'NineOneOne' }.to_json }

      it 'sends proper JSON' do
        expect(subject.notify('message')).to eq true
      end
    end
  end
end
