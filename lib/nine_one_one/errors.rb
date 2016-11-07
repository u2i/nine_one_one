module NineOneOne
  module Errors
    class NineOneOneError < RuntimeError; end

    class ConfigurationError < NineOneOneError; end
    class IncidentReportingError < NineOneOneError; end
  end
end
