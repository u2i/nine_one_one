module NineOneOne
  class Error < RuntimeError; end

  class ConfigurationError < Error; end
  class IncidentReportingError < Error; end
end
