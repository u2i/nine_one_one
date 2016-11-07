require 'net/https'

module NineOneOne
  class SlackService
    attr_reader :webhook_url

    def initialize(webhook_url)
      @webhook_url = webhook_url
    end

    def notify(message)
      uri = URI(webhook_url)
      headers = { 'Content-Type' => 'application/json' }
      request = Net::HTTP::Post.new(uri.path, headers)
      request.body = request_body(message)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      response = http.request(request)

      response.is_a?(Net::HTTPSuccess)
    end

    private

    def request_body(message)
      { text: message }.to_json
    end
  end
end
