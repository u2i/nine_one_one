require 'logger'

module NineOneOne
  class Configuration
    attr_accessor :send_pagers, :pager_duty_integration_key, :slack_enabled, :webhook_url, :logger

    def initialize
      self.send_pagers = false
      self.slack_enabled = false
      self.logger = Logger.new(STDOUT)
    end

    def validate
      validate_send_pagers
      validate_logger
      validate_pager_duty_key
      validate_slack_enabled
    end

    private

    def validate_send_pagers
      unless [true, false].include?(send_pagers)
        raise ConfigurationError, "Illegal 'send_pagers' value: #{send_pagers}"
      end

      raise ConfigurationError, "'send_pagers' is false but no logger given" if !send_pagers && logger.nil?
    end

    # rubocop:disable Style/GuardClause
    def validate_logger
      if logger && !logger.respond_to?(:error)
        raise ConfigurationError, "Logger: #{logger.class} doesnt respond to #error"
      end
    end

    def validate_pager_duty_key
      return true unless send_pagers

      if pager_duty_integration_key.nil? || pager_duty_integration_key.empty?
        raise ConfigurationError, "Missing 'pager_duty_integration_key' parameter"
      end
    end
    # rubocop:enable Style/GuardClause

    def validate_slack_enabled
      unless [true, false].include?(slack_enabled)
        raise ConfigurationError, "Illegal 'slack_enabled' value: #{slack_enabled}"
      end

      raise ConfigurationError, 'Incorrect webhook URL' if slack_enabled && (webhook_url.nil? || webhook_url.empty?)
    end
  end
end
