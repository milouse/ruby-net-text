# frozen_string_literal: true

# This file is derived from "net/http.rb".

require 'socket'
require 'openssl'

require 'uri/gemini'
require_relative 'gemini/response'

module Net
  class GeminiError < StandardError; end

  # == A Gemini client API for Ruby.
  #
  # Net::Gemini provides a rich library which can be used to build
  # Gemini user-agents.  For more details about Gemini see
  # https://gemini.circumlunar.space/docs/specification.html
  #
  # Net::Gemini is designed to work closely with URI.  URI::Gemini#host
  # and URI::Gemini#port are designed to work with Net::Gemini.
  #
  # == Simple Examples
  #
  # All examples assume you have loaded Net::Gemini with:
  #
  #   require 'net/gemini'
  #
  # This will also require 'uri' so you don't need to require it
  # separately.
  #
  # The Net::Gemini methods in the following section do not persist
  # connections.
  #
  # === GET
  #
  # Not yet implemented.
  #
  #   Net::Gemini.get('example.com', '/index.html') # => String
  #
  # === GET by URI
  #
  #   uri = URI('gemini://example.com/index.html?count=10')
  #   Net::Gemini.get(uri) # => String
  #
  # === GET with Dynamic Parameters
  #
  #   uri = URI('gemini://example.com/index.html')
  #   params = { :limit => 10, :page => 3 }
  #   uri.query = URI.encode_www_form(params)
  #
  #   res = Net::Gemini.get_response(uri)
  #   puts res.body if res.body_permitted?
  #
  # === Response Data
  #
  #   u = URI('gemini://exemple.com/home')
  #   res = Net::Gemini.start(u.host, u.port) do |g|
  #     g.request(u)
  #   end
  #
  #   # Status
  #   puts res.status # => '20'
  #   puts res.meta   # => 'text/gemini; charset=UTF-8; lang=en'
  #
  #   # Headers
  #   puts res.header.inspect # => { status: '20',
  #                                  meta: 'text/gemini; charset=UTF-8',
  #                                  mimetype: 'text/gemini',
  #                                  lang: 'en',
  #                                  charset: 'utf-8',
  #                                  format: nil }
  #
  # The lang, charset and format headers will only be provided in case
  # of text/* mimetype, and only if body for 2* status codes.
  #
  #   # Body
  #   puts res.body if res.body_permitted?
  #   puts res.body(flowed: 85)
  #
  # === Following Redirection
  #
  # The Net::Gemini#fetch methods, contrary to the Net::Gemini#request
  # one will try to automatically resolves redirection, leading you to
  # the final destination.
  #
  #   u = URI('gemini://exemple.com/redirect')
  #   res = Net::Gemini.start(u.host, u.port) do |g|
  #     g.request(u)
  #   end
  #   puts "#{res.status} - #{res.meta}" # => '30 final/dest'
  #   puts res.uri.to_s                  # => 'gemini://exemple.com/redirect'
  #
  #   u = URI('gemini://exemple.com/redirect')
  #   res = Net::Gemini.start(u.host, u.port) do |g|
  #     g.fetch(u)
  #   end
  #   puts "#{res.status} - #{res.meta}" # => '20 - text/gemini;'
  #   puts res.uri.to_s                  # => 'gemini://exemple.com/final/dest'
  #
  class Gemini
    def initialize(host, port)
      @host = host
      @port = port
    end

    def request(uri)
      init_sockets
      @ssl_socket.puts "#{uri}\r\n"
      r = GeminiResponse.read_new(@ssl_socket)
      r.uri = uri
      r.reading_body(@ssl_socket)
    ensure
      # Stop remaining connection, even if they should be already cut
      # by the server
      finish
    end

    def fetch(uri, limit = 5)
      raise GeminiError, 'Too many Gemini redirects' if limit.zero?
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
      fetch(uri, limit - 1)
    end

    class << self
      def start(host_or_uri, port = nil)
        if host_or_uri.is_a? URI::Gemini
          host = host_or_uri.host
          port = host_or_uri.port
        else
          host = host_or_uri
        end
        gem = new(host, port)
        return yield(gem) if block_given?
        gem
      end

      def get_response(uri)
        start(uri.host, uri.port) { |gem| gem.fetch(uri) }
      end

      def get(uri)
        get_response(uri).body
      end
    end

    private

    def init_sockets
      @socket = TCPSocket.new(@host, @port)
      ssl_context = OpenSSL::SSL::SSLContext.new
      # For now accept every thing without verification
      ssl_context.set_params(verify_mode: OpenSSL::SSL::VERIFY_NONE)
      # ssl_context.set_params(verify_mode: OpenSSL::SSL::VERIFY_PEER)
      ssl_context.verify_hostname = true
      ssl_context.min_version = OpenSSL::SSL::TLS1_2_VERSION
      @ssl_socket = OpenSSL::SSL::SSLSocket.new(@socket, ssl_context)
      # @ssl_socket.sync_close = true
      @ssl_socket.hostname = @host
      @ssl_socket.connect
    end

    # Closes the SSL and TCP connections.
    def finish
      @ssl_socket.close
      @socket.close
    end
  end
end
