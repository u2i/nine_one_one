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

  def self.emergency(incident_key, description, details_hash = nil)
    use(:default).emergency(incident_key, description, details_hash)
  end

  def self.notify(message)
    use(:default).notify(message)
  end
end
