# frozen_string_literal: true

require_relative 'error'
require_relative 'request'
require_relative 'response'
require_relative '../text/generic'

# rubocop:disable Style/Documentation
module Net
  module Gemini
    # An example client to fetch resources hosted on Gemini network.
    class Client
      attr_writer :certs_path

      def initialize(host, port)
        @host = host
        @port = port
        @certs_path = '~/.cache/gemini/certs'
      end

      # This method can raise an OpenSSL::SSL::SSLError
      def request!(uri)
        init_sockets
        req = Request.new uri
        req.write @ssl_socket
        res = Response.read_new(@ssl_socket)
        res.uri = uri
        res.reading_body(@ssl_socket)
      end

      def request(uri, &block)
        r = request! uri
        if block_given?
          block&.call r
        else
          r.read_body
        end
        r
      rescue OpenSSL::SSL::SSLError => e
        msg = format(
          'SSLError: %<cause>s',
          cause: e.message.sub(/.*state=error: (.+)\Z/, '\1')
        )
        Response.new('59', msg)
      ensure
        # Stop remaining connection, even if they should be already cut
        # by the server
        finish
      end

      def fetch(uri, limit = 5, &block)
        raise Error, 'Too many Gemini redirects' if limit.zero?

        r = request(uri, &block)
        return r unless r.status[0] == '3'

        begin
          uri = handle_redirect(r)
        rescue ArgumentError, URI::InvalidURIError
          return r
        end
        warn "Redirect to #{uri}" if $VERBOSE
        fetch(uri, limit - 1, &block)
      end

      private

      def handle_redirect(response)
        uri = response.uri
        old_url = uri.to_s
        new_uri = URI(response.meta)
        uri.merge!(new_uri)
        raise Error, "Redirect loop on #{uri}" if uri.to_s == old_url

        @host = uri.host
        @port = uri.port
        uri
      end
    end

    def self.start(host_or_uri, port = nil, &block)
      if host_or_uri.is_a? URI::Gemini
        host = host_or_uri.host
        port = host_or_uri.port
      else
        host = host_or_uri
      end
      gem = Client.new(host, port)
      return gem unless block

      yield gem
    end

    def self.get_response(uri, &block)
      start(uri.host, uri.port) { |gem| gem.fetch(uri, &block) }
    end

    def self.get(string_or_uri)
      uri = Net::Text::Generic.build_uri string_or_uri, URI::Gemini
      get_response(uri).body
    end
  end
end
# rubocop:enable Style/Documentation

require_relative 'client/ssl'
