module NineOneOne
  class PagerDutyService
    BASE_HOST = 'events.pagerduty.com'.freeze
    EVENTS_API_V2_ENDPOINT = '/v2/enqueue'.freeze
    THROTTLE_HTTP_STATUS = 403
    THROTTLE_RETRIES = 2
    HIGH_URGENCY_ERROR = 'error'.freeze
    LOW_URGENCY_ERROR = 'warning'.freeze

    def initialize(api_integration_key)
      @api_integration_key = api_integration_key
      @http = Http.new(BASE_HOST)
    end

    def trigger_event(description, source, details_hash, severity = HIGH_URGENCY_ERROR)
      response = nil

      retry_on(THROTTLE_HTTP_STATUS, THROTTLE_RETRIES) do
        body = request_body(description, severity, source, details_hash)
        response = make_request(body)
        response.code.to_i
      end

      # rubocop:disable Style/GuardClause
      unless response.is_a?(Net::HTTPSuccess)
        raise IncidentReportingError, "Failed to create PagerDuty event: #{response.body}"
      end
      # rubocop:enable Style/GuardClause
    end

    alias_method :trigger_high_urgency_event, :trigger_event

    def trigger_low_urgency_event(description, source, details_hash = {})
      trigger_event(description, source, details_hash, NineOneOne::PagerDutyService::LOW_URGENCY_ERROR)
    end

    private

    attr_reader :api_integration_key, :http

    def retry_on(value, retries_number)
      retry_number = 0

      while yield == value && retry_number <= retries_number
        retry_number += 1
        sleep 2 ** retry_number
      end
    end

    def make_request(body)
      headers = {'Content-Type' => 'application/json'}

      http.post(EVENTS_API_V2_ENDPOINT, body, headers)
    end

    def request_body(description, severity, source, details_hash)
      body = {
        routing_key: api_integration_key,
        event_action: 'trigger',
        payload: {
          summary: description,
          severity: severity,
          source: source,
          custom_details: details_hash
        }
      }

      body.to_json
    end
  end
end
