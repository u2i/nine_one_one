require 'net/http'

module NineOneOne
  class PagerDutyService
    BASE_HOST = 'events.pagerduty.com'.freeze
    EVENT_ENDPOINT = '/generic/2010-04-15/create_event.json'.freeze

    THROTTLE_HTTP_STATUS = 403
    THROTTLE_RETRIES = 2

    def initialize(api_integration_key)
      @api_integration_key = api_integration_key
    end

    def trigger_event(incident_key, description, details_hash = nil)
      response = nil

      retry_on(THROTTLE_HTTP_STATUS, THROTTLE_RETRIES) do
        response = make_request(description, details_hash, incident_key)
        response.code.to_i
      end

      unless response.is_a?(Net::HTTPSuccess)
        raise Errors::IncidentReportingError, "Failed to create PagerDuty event: #{response.body}"
      end
    end

    private

    attr_reader :api_integration_key

    def retry_on(value, retries_number)
      retry_number = 0

      while yield == value && retry_number <= retries_number
        retry_number += 1
        sleep 2**retry_number
      end
    end

    def make_request(description, details_hash, incident_key)
      http = Net::HTTP.new(BASE_HOST)

      headers = { 'Content-Type' => 'application/json' }
      body = request_body(incident_key, description, details_hash)

      request = Net::HTTP::Post.new(EVENT_ENDPOINT, headers)
      request.body = body

      http.request(request)
    end

    def request_body(incident_key, description, details_hash)
      body = {
        service_key: api_integration_key,
        event_type: 'trigger',
        incident_key: incident_key,
        description: description
      }
      body[:details] = details_hash if details_hash

      body.to_json
    end
  end
end
