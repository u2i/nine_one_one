module NineOneOne
  class SlackService
    def initialize(webhook_url, opts = {})
      uri = URI(webhook_url)

      @channel = opts[:channel]
      @http = opts[:http] || Http.new(uri.host, uri.scheme)
      @path = uri.path
      @username = opts[:username]
    end

    def notify(message)
      body = request_body(message)
      headers = { 'Content-Type' => 'application/json' }
      http.post(path, body, headers)
    end

    private

    attr_reader :channel, :http, :path, :username

    def request_body(message)
      body = message.is_a?(Hash) ? message : { text: message }
      body[:channel] = channel unless channel.nil?
      body[:username] = username unless username.nil?

      body.to_json
    end
  end
end
