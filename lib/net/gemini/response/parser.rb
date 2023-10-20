# frozen_string_literal: true

module Net
  module Gemini
    # Reopen Response class to add specific private method to parse
    # text/gemini documents.
    class Response
      private

      def parse_meta
        header = { status: @status, meta: @meta, mimetype: nil }
        return header unless body_permitted?
        mime = { lang: nil, charset: 'utf-8', format: nil }
        raw_meta = meta.split(';').map(&:strip)
        header[:mimetype] = raw_meta.shift
        return header unless raw_meta.any?
        raw_meta.map { |m| m.split('=') }.each do |opt|
          key = opt[0].downcase.to_sym
          next unless mime.has_key? key
          mime[key] = opt[1].downcase
        end
        header.merge(mime)
      end

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
        uri = @uri.merge(uri) if @uri && uri.is_a?(URI::Generic)
        @links << { uri: uri, label: m[2]&.chomp }
      end

      def parse_body
        buf = StringIO.new(@body)
        while (line = buf.gets)
          if line.start_with?('```')
            parse_preformatted_block(line, buf)
          elsif line.start_with?('=>')
            parse_link(line)
          end
        end
      end
    end
  end
end
