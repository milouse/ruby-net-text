# frozen_string_literal: true

require 'English'

require 'uri/gemini'

module Net
  class GeminiBadRequest < StandardError; end

  #
  # The syntax of Gemini Requests are defined in the Gemini
  # specification, section 2.
  #
  # @see https://gemini.circumlunar.space/docs/specification.html
  #
  class GeminiRequest
    attr_reader :uri

    def initialize(uri_or_str)
      if uri_or_str.is_a? URI::Gemini
        @uri = uri_or_str
      elsif uri_or_str.length > 1024
        raise GeminiBadRequest, "Request too long: #{uri_or_str.dump}"
      else
        @uri = URI(uri_or_str)
      end
    end

    def path
      @uri.path
    end

    def write(sock)
      sock.puts "#{@uri}\r\n"
    end

    class << self
      def read_new(sock)
        # Read up to 1026 bytes:
        # - 1024 bytes max for the URL
        # - 2 bytes for <CR><LF>
        str = sock.gets($INPUT_RECORD_SEPARATOR, 1026)
        m = /\A(.*)\r\n\z/.match(str)
        raise GeminiBadRequest, "Malformed request: #{str.dump}" if m.nil?
        new(m[1])
      end
    end
  end
end
