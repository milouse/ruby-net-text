# frozen_string_literal: true

# This file is derived from "net/http.rb".

require 'socket'
require 'openssl'
require 'fileutils'

require 'uri/gemini'
require_relative 'gemini/request'
require_relative 'gemini/response'
require_relative 'gemini/ssl'

module Net
  class GeminiError < StandardError; end

  # == A Gemini client API for Ruby.
  #
  # Net::Gemini provides a rich library which can be used to build
  # Gemini user-agents.
  # @see https://gemini.circumlunar.space/docs/specification.html
  #
  # Net::Gemini is designed to work closely with URI.
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
  # === GET by URI
  #
  #   uri = URI('gemini://gemini.circumlunar.space/')
  #   Net::Gemini.get(uri) # => String
  #
  # === GET with Dynamic Parameters
  #
  #   uri = URI('gemini://gus.guru/search')
  #   uri.query = URI.encode_www_form('test')
  #
  #   res = Net::Gemini.get_response(uri)
  #   puts res.body if res.body_permitted?
  #
  # === Response Data
  #
  #   res = Net::Gemini.get_response(URI('gemini://gemini.circumlunar.space/'))
  #
  #   # Status
  #   puts res.status # => '20'
  #   puts res.meta   # => 'text/gemini; charset=UTF-8; lang=en'
  #
  #   # Headers
  #   puts res.header.inspect
  #   # => { status: '20', meta: 'text/gemini; charset=UTF-8',
  #           mimetype: 'text/gemini', lang: 'en',
  #           charset: 'utf-8', format: nil }
  #
  # The lang, charset and format headers will only be provided in case
  # of `text/*` mimetype, and only if body for 2* status codes.
  #
  #   # Body
  #   puts res.body if res.body_permitted?
  #   puts res.body(flowed: 85)
  #
  # === Following Redirection
  #
  # The {#fetch} method, contrary to the {#request} one will try to
  # automatically resolves redirection, leading you to the final
  # destination.
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
    attr_writer :certs_path

    def initialize(host, port)
      @host = host
      @port = port
      @certs_path = '~/.cache/gemini/certs'
    end

    def request(uri)
      init_sockets
      req = GeminiRequest.new uri
      req.write @ssl_socket
      res = GeminiResponse.read_new(@ssl_socket)
      res.uri = uri
      res.reading_body(@ssl_socket)
    ensure
      # Stop remaining connection, even if they should be already cut
      # by the server
      finish
    end

    def fetch(uri, limit = 5)
      raise GeminiError, 'Too many Gemini redirects' if limit.zero?
      r = request(uri)
      return r unless r.status[0] == '3'
      begin
        uri = handle_redirect(r)
      rescue ArgumentError, URI::InvalidURIError
        return r
      end
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

    def handle_redirect(response)
      uri = response.uri
      old_url = uri.to_s
      new_uri = URI(response.meta)
      uri.merge!(new_uri)
      raise GeminiError, "Redirect loop on #{uri}" if uri.to_s == old_url
      @host = uri.host
      @port = uri.port
      uri
    end

    include ::Gemini::SSL
  end
end
