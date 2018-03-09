require 'spec_helper'

RSpec.shared_examples 'proper requests and response' do
  it 'sends proper slack apie request (as defined in the vcr fixture) and replies with http success response' do
    is_expected.to be_a(Net::HTTPSuccess)
  end
end

RSpec.describe NineOneOne::SlackService do
  let(:webhook_url) { 'https://hooks.slack.com/services/XXX' }

  describe '#notify' do
    subject { slack_service.notify(message) }

    let(:opts) { {} }
    let(:slack_service) { described_class.new(webhook_url, opts) }

    context 'when string message' do
      let(:message) { 'any string message' }

      context 'when API call succeeds' do
        context 'when no additional fields' do
          use_vcr_cassette 'slack_notification_string_success'

          it_behaves_like 'proper requests and response'
        end

        context 'when one optional field' do
          let(:opts) { {username: 'NineOneOne'} }

          use_vcr_cassette 'slack_notification_with_username'

          it_behaves_like 'proper requests and response'
        end

        context 'when all optional fields' do
          let(:opts) { {username: 'NineOneOne', channel: '#ruby-rails'} }

          use_vcr_cassette 'slack_notification_all_fields'

          it_behaves_like 'proper requests and response'
        end
      end

      context 'when API call fails' do
        use_vcr_cassette 'slack_notification_failure'

        it 'sends proper request (as defined in the vcr fixture) but replies with an error ' do
          is_expected.to be_a(Net::HTTPBadRequest)
        end
      end
    end

    context 'when hash message' do
      let(:message) do
        {attachments: [{pretext: 'us staging', title: 'some title', text: 'msg 1\nmsg 2'}]}
      end

      use_vcr_cassette 'slack_notification_hash_success'

      it_behaves_like 'proper requests and response'
    end
  end
end
