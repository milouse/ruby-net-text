# frozen_string_literal: true

# This file is derived from "net/http.rb".

require 'socket'
require 'fileutils'

require 'uri/gopher'

module Net
  # == A Gopher client API for Ruby.
  #
  # Net::Gopher provides a library which can be used to build Gopher
  # user-agents.
  #
  # Net::Gopher is designed to work closely with URI.
  #
  # == Simple Examples
  #
  # All examples assume you have loaded Net::Gopher with:
  #
  #   require 'net/gopher'
  #
  # This will also require 'uri' so you don't need to require it
  # separately.
  #
  # The Net::Gopher methods in the following section do not persist
  # connections.
  #
  # === GET by URI
  #
  #   uri = URI('gopher://thelambdalab.xyz/1/projects/elpher/')
  #   Net::Gopher.get(uri) # => String
  #
  class Gopher
    class << self
      def get(string_or_uri)
        case string_or_uri
        when URI::Gopher
          uri = string_or_uri
        when String
          uri = URI(string_or_uri)
        else
          raise ArgumentError, 'Not a String or an URI::Gopher'
        end
        request uri
      end

      private

      def request(uri)
        sock = TCPSocket.new(uri.host, uri.port)
        unless uri.is_a? URI::Gopher
          raise ArgumentError, 'uri is not an URI::Gopher'
        end
        sock.puts "#{uri.selector}\r\n"
        sock.read
      ensure
        # Stop remaining connection, even if they should be already cut
        # by the server
        sock&.close
      end
    end
  end
end
