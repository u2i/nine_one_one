require_relative './nine_one_one/errors'
require_relative './nine_one_one/version'
require_relative './nine_one_one/configuration'
require_relative './nine_one_one/log_service'
require_relative './nine_one_one/pager_duty_service'

module NineOneOne
  def self.service
    if config.send_pagers
      PagerDutyService.new(config.pager_duty_integration_key)
    else
      LogService.new(config.logger)
    end
  end

  def self.configure
    config = Configuration.new

    yield config

    config.validate

    @config = config
  end

  def self.config
    raise Errors::ConfigurationError, 'NineOneOne has not been configured!' if @config.nil?

    @config
  end
end
