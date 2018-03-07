module NineOneOne
  class LogService
    def initialize(logger)
      @logger = logger
    end

    def trigger_event(description, source, details_hash, severity)
      logger.error "TRIGGERED INCIDENT (#{severity}): #{description} | #{details_hash} | #{source}"
    end

    def notify(message)
      logger.info(message)
    end

    private

    attr_reader :logger
  end
end
