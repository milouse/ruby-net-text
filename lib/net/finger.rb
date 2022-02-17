# frozen_string_literal: true

# This file is derived from "net/http.rb".

require 'socket'

require_relative '../uri/finger'

module Net
  # == A Finger client API for Ruby.
  #
  # Net::Finger provides a library which can be used to build Finger
  # user-agents.
  #
  # Net::Finger is designed to work closely with URI.
  #
  # == Simple Examples
  #
  # All examples assume you have loaded Net::Finger with:
  #
  #   require 'net/finger'
  #
  # This will also require 'uri' so you don't need to require it
  # separately.
  #
  # The Net::Finger methods in the following section do not persist
  # connections.
  #
  # === GET by URI
  #
  #   uri = URI('finger://skyjake.fi/jaakko')
  #   Net::Finger.get(uri) # => String
  #
  class Finger
    class << self
      def get(string_or_uri)
        case string_or_uri
        when URI::Finger
          uri = string_or_uri
        when String
          uri = URI(string_or_uri)
        else
          raise ArgumentError, 'Not a String or an URI::Finger'
        end
        request uri
      end

      private

      def request(uri)
        sock = TCPSocket.new(uri.host, uri.port)
        unless uri.is_a? URI::Finger
          raise ArgumentError, 'uri is not an URI::Finger'
        end
        sock.puts uri.name.to_s
        sock.read
      ensure
        # Stop remaining connection, even if they should be already cut
        # by the server
        sock&.close
      end
    end
  end
end
