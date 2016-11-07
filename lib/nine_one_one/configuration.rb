module NineOneOne
  class Configuration
    attr_accessor :send_pagers, :pager_duty_integration_key, :logger

    def validate
      valid_send_pagers?
      valid_logger?
      valid_pager_duty_key?
    end

    private

    def valid_send_pagers?
      raise ConfigurationError, "Missing 'send_pagers' parameter" if send_pagers.nil?

      unless [true, false].include?(send_pagers)
        raise ConfigurationError, "Illegal 'send_pagers' value: #{send_pagers}"
      end

      raise ConfigurationError, "'send_pagers' is false but no logger given" if !send_pagers && logger.nil?
    end

    # rubocop:disable Style/GuardClause
    def valid_logger?
      if logger && !logger.respond_to?(:error)
        raise ConfigurationError, "Logger: #{logger.class} doesnt respond to #error"
      end
    end

    def valid_pager_duty_key?
      return true unless send_pagers

      if pager_duty_integration_key.nil? || pager_duty_integration_key.empty?
        raise ConfigurationError, "Missing 'pager_duty_integration_key' parameter"
      end
    end
    # rubocop:enable Style/GuardClause
  end
end
