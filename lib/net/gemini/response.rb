# frozen_string_literal: true

require 'English'
require 'stringio'

require_relative 'error'
require_relative '../text/reflow'

module Net
  module Gemini
    #
    # The syntax of Gemini Responses are defined in the Gemini
    # specification, section 3.
    #
    # @see https://gemini.circumlunar.space/docs/specification.html
    #
    # See {Net::Gemini} documentation to see how to interract with a
    # Response.
    #
    class Response
      # @return [String] The Gemini response <STATUS> string.
      # @example '20'
      attr_reader :status

      # @return [String] The Gemini response <META> message sent by the server.
      # @example 'text/gemini'
      attr_reader :meta

      # @return [Hash] The Gemini response <META>.
      attr_reader :header

      # The Gemini response main content as a string.
      attr_writer :body

      # The URI related to this response as an URI object.
      attr_accessor :uri

      # @return [Array<String>] All links found on a Gemini response of MIME
      #   text/gemini
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
        while (line = sock.gets)
          raw_body << line
        end
        @body = encode_body(raw_body.join)
        return self unless @header[:mimetype] == 'text/gemini'
        parse_body
        self
      end

      # Return the response body (i.e. the requested document content).
      #
      # @param reflow_at [Integer] The column at which body content must be
      #   reflowed. Default is -1, which means "do not reflow".
      # @return [String] the body content
      def body(reflow_at: -1)
        return '' if @body.nil? # Maybe not ready?
        return @body if reflow_at < 0 || @header[:format] == 'fixed'

        Net::Text::Reflow.format_body(@body, reflow_at)
      end

      class << self
        def read_new(sock)
          # Read up to 1029 bytes:
          # - 3 bytes for code and space separator
          # - 1024 bytes max for the message
          # - 2 bytes for <CR><LF>
          str = sock.gets($INPUT_RECORD_SEPARATOR, 1029)
          m = /\A([1-6]\d) (.*)\r\n\z/.match(str)
          raise BadResponse, "wrong status line: #{str.dump}" if m.nil?
          new(*m.captures)
        end
      end

      private

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
end

require_relative 'response/parser'
