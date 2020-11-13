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
    # The Gemini response <STATUS> string.
    #
    # For example, '20'.
    attr_reader :status

    # The Gemini response <META> message sent by the server as a string.
    #
    # For example, 'text/gemini'.
    attr_reader :meta

    # The Gemini response <META> as a qualified Hash.
    attr_reader :header

    # The URI related to this response as an URI object.
    attr_accessor :uri

    # The Gemini response main content as a string.
    attr_accessor :body

    # All links found on a Gemini response of MIME text/gemini, as an
    #   array.
    attr_reader :links

    def initialize(status = nil, meta = nil)
      @status = status
      @meta = meta
      @header = parse_meta
      @uri = nil
      @body = nil
      @links = []
      @preformatted_blocks = []
    end

    def body_permitted?
      @status && @status[0] == '2'
    end

    def reading_body(sock)
      return self unless body_permitted?
      raw_body = []
      while line = sock.gets
        raw_body << line
      end
      @body = encode_body(raw_body.join)
      return self unless @header[:mimetype] == 'text/gemini'
      parse_body
      self
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

    def parse_meta
      header = {
        status: @status,
        meta: @meta,
        mimetype: nil,
        lang: nil,
        charset: 'utf-8'
      }
      return header unless body_permitted?
      raw_meta = meta.split(';').map(&:strip)
      header[:mimetype] = raw_meta.shift
      return header unless raw_meta.any?
      raw_meta.each do |m|
        opt = m.split('=')
        key = opt[0].downcase.to_sym
        next unless [:lang, :charset, :format].include? key
        header[key] = opt[1].downcase
      end
      header
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

    def encode_body(body)
      return body unless @header[:mimetype].start_with?('text/')
      if @header[:charset] && @header[:charset] != 'utf-8'
        # If body use another charset than utf-8, we need first to
        # declare the raw byte string as using this chasret
        body.force_encoding(@header[:charset])
        # Then we can safely try to convert it to utf-8
        return body.encode('utf-8')
      end
      # Just declare that the body uses utf-8
      body.force_encoding('utf-8')
    end
  end
end
