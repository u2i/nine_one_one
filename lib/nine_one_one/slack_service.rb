module NineOneOne
  class SlackService
    def initialize(webhook_url)
      uri = URI(webhook_url)

      @http = Http.new(uri.host, uri.scheme)
      @path = uri.path
    end

    def notify(message)
      body = request_body(message)
      headers = { 'Content-Type' => 'application/json' }

      response = http.post(path, body, headers)

      response.is_a?(Net::HTTPSuccess)
    end

    private

    attr_reader :http, :path

    def request_body(message)
      { text: message }.to_json
    end
  end
end
