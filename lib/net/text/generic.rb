# frozen_string_literal: true

require 'socket'

module Net
  module Text
    # Generic interface to be used by specific network protocol implementation.
    class Generic
      def self.request(uri, query)
        sock = TCPSocket.new(uri.host, uri.port)
        sock.puts query
        sock.read
      ensure
        # Stop remaining connection, even if they should be already cut
        # by the server
        sock&.close
      end

      def self.build_uri(string_or_uri, uri_class)
        string_or_uri = URI(string_or_uri) if string_or_uri.is_a?(String)
        return string_or_uri if string_or_uri.is_a?(uri_class)

        raise ArgumentError, "uri is not a String, nor an #{uri_class.name}"
      end
    end
  end
end
