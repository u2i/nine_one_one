module NineOneOne
  class LogService
    def initialize(logger)
      @logger = logger
    end

    def trigger_event(incident_key, description, details_hash = nil)
      logger.error "TRIGGERED INCIDENT #{incident_key}: #{description} #{details_hash}"
    end

    def notify(message)
      logger.info(message)
    end

    private

    attr_reader :logger
  end
end
