require 'logger'

module NineOneOne
  class Configuration
    attr_accessor :send_pagers, :pager_duty_integration_key,
                  :slack_channel, :slack_enabled, :slack_username, :slack_webhook_url,
                  :logger

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
      validate_slack_opts
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
      raise ConfigurationError, "Logger: #{logger.class} doesn't respond to #error" unless logger.respond_to?(:error)
      raise ConfigurationError, "Logger: #{logger.class} doesn't respond to #info" unless logger.respond_to?(:info)
    end

    def validate_pager_duty_key
      return true unless send_pagers

      if pager_duty_integration_key.nil? || pager_duty_integration_key.empty?
        raise ConfigurationError, "Missing 'pager_duty_integration_key' parameter"
      end
    end

    def validate_slack_enabled
      unless [true, false].include?(slack_enabled)
        raise ConfigurationError, "Illegal 'slack_enabled' value: #{slack_enabled}"
      end

      if slack_enabled && (slack_webhook_url.nil? || slack_webhook_url.empty?)
        raise ConfigurationError, 'Incorrect Slack webhook URL'
      end
    end

    def validate_slack_opts
      unless slack_username.nil? || slack_username.is_a?(String)
        raise ConfigurationError, "Illegal 'slack_username' value: #{slack_username}"
      end

      unless slack_channel.nil? || slack_channel.is_a?(String)
        raise ConfigurationError, "Illegal 'slack_channel' value: #{slack_channel}"
      end
    end
    # rubocop:enable Style/GuardClause
  end
end
