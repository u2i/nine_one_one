module NineOneOne
  class Notifier
    def initialize(config)
      @config = config
    end

    def emergency(description, source, details_hash:, severity:, dedup_key:)
      emergency_service.trigger_event(description, source, details_hash: details_hash, severity: severity,
                                                           dedup_key: dedup_key)
    end

    def notify(message)
      notification_service.notify(message)
    end

    def emergency_service
      if config.send_pagers
        PagerDutyService.new(config.pager_duty_integration_key)
      else
        LogService.new(config.logger)
      end
    end

    def notification_service
      if config.slack_enabled
        SlackService.new(config.slack_webhook_url, username: config.slack_username,
                                                   channel: config.slack_channel)
      else
        LogService.new(config.logger)
      end
    end

    private

    attr_reader :config
  end
end
