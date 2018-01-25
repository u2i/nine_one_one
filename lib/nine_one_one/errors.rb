module NineOneOne
  class Error < RuntimeError; end

  class NotConfiguredError < Error; end
  class ConfigurationError < Error; end
  class IncidentReportingError < Error; end
  class NotificationError < Error; end

  class HttpError < Error; end
  class SSLError < HttpError; end
  class TimeoutError < HttpError; end
  class ConnectionFailedError < HttpError; end
end
