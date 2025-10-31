# frozen_string_literal: true

require_relative '../../uri/gemini'

module Net
  module Text
    class GmiParser
      attr_reader :links, :preformatted_blocks

      def initialize(base_uri: nil)
        @base_uri = URI(base_uri)
        @links = []
        @preformatted_blocks = []
      end

      def parse(str_or_io)
        buf = str_or_io.respond_to?(:gets) ? str_or_io : StringIO.new(str_or_io)
        while (line = buf.gets)
          if line.start_with?('```')
            parse_preformatted_block(line, buf)
          elsif line.start_with?('=>')
            parse_link(line)
          end
        end
      end

      private

      def parse_preformatted_block(line, buf)
        cur_block = { meta: line[3..].chomp, content: '' }
        while (line = buf.gets)
          if line.start_with?('```')
            @preformatted_blocks << cur_block
            break
          end
          cur_block[:content] += line
        end
      end

      def parse_link(line)
        m = line.strip.match(/\A=>\s*([^\s]+)(?:\s*(.+))?\z/)
        return if m.nil?

        begin
          uri = URI(m[1])
        rescue URI::InvalidURIError
          return
        end
        uri = @base_uri.merge(uri) if @base_uri && uri.is_a?(URI::Generic)
        @links << { uri: uri, label: m[2]&.chomp }
      end
    end
  end
end
