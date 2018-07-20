module NineOneOne
  class PagerDutyService
    BASE_HOST = 'events.pagerduty.com'.freeze
    EVENTS_API_V2_ENDPOINT = '/v2/enqueue'.freeze
    THROTTLE_HTTP_STATUS = 403
    THROTTLE_RETRIES = 2
    HIGH_URGENCY_ERROR = 'error'.freeze

    def initialize(api_integration_key)
      @api_integration_key = api_integration_key
      @http = Http.new(BASE_HOST)
    end

    def trigger_event(description, source, details_hash: nil, severity: PagerDutyService::HIGH_URGENCY_ERROR,
                      dedup_key: nil)
      response = nil

      retry_on(THROTTLE_HTTP_STATUS, THROTTLE_RETRIES) do
        body = request_body(description, severity, source, details_hash, dedup_key)
        response = make_request(body)
        response.code.to_i
      end

      # rubocop:disable Style/GuardClause
      unless response.is_a?(Net::HTTPSuccess)
        raise IncidentReportingError, "Failed to create PagerDuty event: #{response.body}"
      end
      # rubocop:enable Style/GuardClause
    end

    private

    attr_reader :api_integration_key, :http

    def retry_on(value, retries_number)
      retry_number = 0

      while yield == value && retry_number <= retries_number
        retry_number += 1
        sleep 2**retry_number
      end
    end

    def make_request(body)
      headers = {'Content-Type' => 'application/json'}

      http.post(EVENTS_API_V2_ENDPOINT, body, headers)
    end

    def request_body(description, severity, source, details_hash, dedup_key)
      body = {
        routing_key: api_integration_key,
        event_action: 'trigger',
        dedup_key: dedup_key,
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
