# frozen_string_literal: true

require 'stringio'

module Net
  class GeminiBadResponse < StandardError; end

  #
  # The syntax of Gemini Responses are defined in the Gemini
  #   specification[1], section 3.
  #
  # [1] https://gemini.circumlunar.space/docs/specification.html
  #
  class GeminiResponse
    # The Gemini <STATUS> string. For example, '20'.
    attr_reader :status

    # The Gemini <META> message sent by the server. For example,
    #   'text/gemini'.
    attr_reader :meta

    # The MIME type of the body content as a string, if available.
    attr_reader :mimetype

    # The charset of the body content as a string, if available.
    attr_reader :charset

    # The locale of the body content as a string, if available.
    attr_reader :lang

    # The URI related to this response as an URI object.
    attr_accessor :uri

    # The Gemini response main content as a string.
    attr_accessor :body

    # All links found on a Gemini response of MIME text/gemini, as an
    #   array.
    attr_reader :links

    def initialize(status = nil, meta = nil)
      @status = status
      @mimetype, @lang, @charset = parse_meta(meta)
      @meta = meta
      @uri = nil
      @body = nil
      @links = []
      @preformatted_blocks = []
    end

    def body_permitted?
      @status && @status[0] == '2'
    end

    def reading_body(sock)
      raw_body = []
      while line = sock.gets
        raw_body << line
      end
      @body = raw_body.join
      return self unless @mimetype == 'text/gemini'
      parse_body
      self
    end

    def header
      {
        status: @status,
        meta: @meta,
        mimetype: @mimetype,
        lang: @lang,
        charset: @charset
      }
    end

    class << self
      def read_new(sock)   #:nodoc: internal use only
        code, msg = read_status_line(sock)
        new(code, msg)
      end

      private

      def read_status_line(sock)
        # Read up to 1027 bytes:
        # - 3 bytes for code and space separator
        # - 1024 bytes max for the message
        str = sock.gets($/, 1027)
        m = /\A([1-6]\d) (.*)\r\n\z/.match(str)
        raise GeminiBadResponse, "wrong status line: #{str.dump}" if m.nil?
        m.captures
      end
    end

    private

    def parse_meta(meta)
      data = [nil, nil, nil]
      return data unless body_permitted?
      raw_meta = meta.split(';').map(&:strip)
      data[0] = raw_meta.shift
      return data unless raw_meta.any?
      raw_meta.each do |m|
        opt = m.split('=')
        case opt[0]
        when 'lang'
          data[1] = opt[1]
        when 'charset'
          data[2] = opt[1]
        end
      end
    end

    def parse_preformatted_block(line, buf)
      cur_block = { meta: line[3..].strip, content: '' }
      while line = buf.gets
        if line.start_with?('```')
          @preformatted_blocks << cur_block
          break
        end
        cur_block[:content] += line
      end
    end

    def parse_link(line)
      line.strip!
      m = line.match(/\A=>\s*([^\s]+)(?:\s*(.+))?\z/)
      return if m.nil?
      uri = URI(m[1])
      uri = @uri.merge(uri) if @uri && uri.is_a?(URI::Generic)
      @links << { uri: uri, label: m[2]&.strip }
    end

    def parse_body
      buf = StringIO.new(@body)
      while line = buf.gets
        if line.start_with?('```')
          parse_preformatted_block(line, buf)
        elsif line.start_with?('=>')
          parse_link(line)
        end
      end
    end
  end
end
