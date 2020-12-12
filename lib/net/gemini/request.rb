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
      # In any case, make some sanity check over this uri-like think
      url = uri_or_str.to_s
      if url.length > 1024
        raise GeminiBadRequest, "Request too long: #{url.dump}"
      end
      @uri = URI(url)
      return if uri.is_a? URI::Gemini
      raise GeminiBadRequest, "Not a Gemini URI: #{url.dump}"
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
