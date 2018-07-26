require_relative './nine_one_one/errors'
require_relative './nine_one_one/http'
require_relative './nine_one_one/version'
require_relative './nine_one_one/configuration'
require_relative './nine_one_one/notifier'
require_relative './nine_one_one/log_service'
require_relative './nine_one_one/slack_service'
require_relative './nine_one_one/pager_duty_service'

module NineOneOne
  def self.configure(type = :default)
    config = Configuration.new

    yield config

    config.validate

    configs[type] = config
  end

  def self.use(type = :default)
    config = configs.fetch(type) { raise NotConfiguredError, "Configuration type=#{type} is not configured." }
    Notifier.new(config)
  end

  def self.configs
    @configs ||= {}
  end

  def self.emergency(description, source: Socket.gethostname, dedup_key: nil,
                     severity: PagerDutyService::HIGH_URGENCY_ERROR, details_hash: nil)
    use(:default).emergency(description, source: source, dedup_key: dedup_key, severity: severity,
                                 details_hash: details_hash)

  end

  def self.notify(message)
    use(:default).notify(message)
  end

  def self.notification_service
    use(:default).notification_service
  end

  def self.emergency_service
    use(:default).emergency_service
  end
end
