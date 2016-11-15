begin
  require 'net/https'
rescue LoadError
  warn 'Warning: no such file to load -- net/https. Make sure openssl is installed if you want ssl support'
  require 'net/http'
end
require 'zlib'

# a minimal wrapper around Net::HTTP which encapsulates ugly Net::HTTP errors
# and throws NineOneOne:Errors instead. The implementation is based on
# Faraday's Net::HTTP adapter
module NineOneOne
  class Http
    # rubocop:disable Style/MutableConstant
    NET_HTTP_EXCEPTIONS = [
      EOFError,
      Errno::ECONNABORTED,
      Errno::ECONNREFUSED,
      Errno::ECONNRESET,
      Errno::EHOSTUNREACH,
      Errno::EINVAL,
      Errno::ENETUNREACH,
      Errno::EPIPE,
      Net::HTTPBadResponse,
      Net::HTTPHeaderSyntaxError,
      Net::ProtocolError,
      SocketError,
      Zlib::GzipFile::Error
    ]
    # rubocop:enable Style/MutableConstant

    NET_HTTP_EXCEPTIONS << OpenSSL::SSL::SSLError if defined?(OpenSSL)
    NET_HTTP_EXCEPTIONS << Net::OpenTimeout if defined?(Net::OpenTimeout)

    attr_reader :net_http

    def initialize(base_host, scheme = 'https')
      port, use_ssl = scheme == 'https' ? [443, true] : [80, false]

      @net_http = Net::HTTP.new(base_host, port)

      @net_http.use_ssl = use_ssl
    end

    def post(path, body, headers)
      post!(path, body, headers)
    rescue *NET_HTTP_EXCEPTIONS => err
      err_class = if defined?(OpenSSL) && err.is_a?(OpenSSL::SSL::SSLError)
                    SSLError
                  else
                    ConnectionFailedError
                  end

      raise err_class, err
    rescue Timeout::Error, Errno::ETIMEDOUT => err
      raise TimeoutError, err
    end

    private

    def post!(path, body, headers)
      request = Net::HTTP::Post.new(path, headers)
      request.body = body

      net_http.request(request)
    end
  end
end
