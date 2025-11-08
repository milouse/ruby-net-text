# frozen_string_literal: true

module Net
  module Gemini
    # Reopen Response class to add specific private method to parse
    # meta data.
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
    end
  end
end
