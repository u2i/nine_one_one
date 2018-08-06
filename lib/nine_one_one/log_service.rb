module NineOneOne
  class LogService
    def initialize(logger)
      @logger = logger
    end

    def trigger_event(description, details_hash)
      logger.error("TRIGGERED INCIDENT: #{description} (#{details_hash})")
    end

    def notify(message)
      logger.info(message)
    end

    private

    attr_reader :logger
  end
end
