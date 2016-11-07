module NineOneOne
  class Error < RuntimeError; end

  class ConfigurationError < Error; end
  class IncidentReportingError < Error; end
  class NotificationError < Error; end
end
