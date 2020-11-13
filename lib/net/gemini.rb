# frozen_string_literal: true

require 'socket'
require 'openssl'

require 'uri/gemini'
require_relative 'gemini/response'

module Net
  class Gemini
    def initialize(host, port)
      @socket = TCPSocket.open host, port
      ssl_context = OpenSSL::SSL::SSLContext.new
      # For now accept every thing without verification
      ssl_context.set_params(verify_mode: OpenSSL::SSL::VERIFY_NONE)
      #ssl_context.set_params(verify_mode: OpenSSL::SSL::VERIFY_PEER)
      ssl_context.verify_hostname = true
      ssl_context.min_version = OpenSSL::SSL::TLS1_2_VERSION
      @ssl_socket = OpenSSL::SSL::SSLSocket.new(@socket, ssl_context)
      @ssl_socket.sync_close = true
      @ssl_socket.hostname = host
      @ssl_socket.connect
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
      @ssl_socket.puts "#{uri.to_s}\r\n"
      r = GeminiResponse.read_new(@ssl_socket)
      r.uri = uri
      r.reading_body(@ssl_socket)
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
  end
end
