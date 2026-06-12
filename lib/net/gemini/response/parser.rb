# frozen_string_literal: true

module Net
  module Gemini
    # Reopen Response class to add specific private method to parse
    # text/gemini documents.
    class Response
      private

      def received_mime(raw_meta)
        meta_data = raw_meta.map { |m| m.split('=') }
        mime = { lang: nil, charset: 'utf-8', format: nil }
        new_mime = meta_data.filter_map do |opt|
          next if opt.empty?

          key = opt[0].downcase.to_sym
          next unless mime.has_key? key

          [key, opt[1].downcase]
        end
        mime.merge new_mime.to_h
      end

      def parse_meta
        header = { status: @status, meta: @meta, mimetype: nil }
        return header unless body_permitted?

        raw_meta = meta.split(';').map(&:strip)
        header[:mimetype] = raw_meta.shift
        return header unless raw_meta.any?

        header.merge received_mime(raw_meta)
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
        mono_block_open = false
        while (line = buf.gets)
          mono_block_open = !mono_block_open if line.start_with?('```')

          # Do not parse links inside preformatted block
          next if mono_block_open

          next unless line.start_with?('=>')

          parse_link(line)
        end
      end
    end
  end
end
