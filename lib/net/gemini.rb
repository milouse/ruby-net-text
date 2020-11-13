# frozen_string_literal: true

require 'socket'
require 'openssl'

require 'uri/gemini'
require_relative 'gemini/response'

module Net
  class GeminiError < StandardError; end

  class Gemini
    def initialize(host, port)
      @host = host
      @port = port
    end

    def start
      if block_given?
        begin
          return yield(self)
        ensure
          finish
        end
      end
      self
    end

    # Closes the SSL and TCP connections.
    def finish
      @ssl_socket.close
      @socket.close
    end

    def request(uri)
      init_sockets
      @ssl_socket.puts "#{uri.to_s}\r\n"
      r = GeminiResponse.read_new(@ssl_socket)
      r.uri = uri
      r.reading_body(@ssl_socket)
    end

    def fetch(uri, limit = 5)
      raise GeminiError, 'Too many Gemini redirects' if limit == 0
      r = request(uri)
      return r unless r.status[0] == '3'
      old_url = uri.to_s
      begin
        new_uri = URI(r.meta)
        uri.merge!(new_uri)
      rescue ArgumentError, URI::InvalidURIError
        return r
      end
      raise GeminiError, "Redirect loop on #{uri}" if uri.to_s == old_url
      warn "Redirect to #{uri}" if $VERBOSE
      # Stop remaining connection, even if they should be already cut
      # by the server
      finish
      fetch(uri, limit - 1)
    end

    def Gemini.start(host_or_uri, port = nil, &block)
      if host_or_uri.is_a? URI::Gemini
        host = host_or_uri.host
        port = host_or_uri.port
      else
        host = host_or_uri
      end
      new(host, port).start(&block)
    end

    private

    def init_sockets
      @socket = TCPSocket.new(@host, @port)
      ssl_context = OpenSSL::SSL::SSLContext.new
      # For now accept every thing without verification
      ssl_context.set_params(verify_mode: OpenSSL::SSL::VERIFY_NONE)
      #ssl_context.set_params(verify_mode: OpenSSL::SSL::VERIFY_PEER)
      ssl_context.verify_hostname = true
      ssl_context.min_version = OpenSSL::SSL::TLS1_2_VERSION
      @ssl_socket = OpenSSL::SSL::SSLSocket.new(@socket, ssl_context)
      #@ssl_socket.sync_close = true
      @ssl_socket.hostname = @host
      @ssl_socket.connect
    end
  end
end
