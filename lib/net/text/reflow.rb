# frozen_string_literal: true

module Net
  module Text
    # Contains helper methods to correctly display texts with long lines.
    #
    # This module expect given text to be Gemtext inspired (i.e. links
    # prefixed with => and ``` delimitting code blocks).
    module Reflow
      def self.reflow_line_prefix(line)
        m = line.match(/\A([*#>]+ )/)
        return '' unless m
        # Each quote line should begin with the quote mark
        return m[1] if m[1].start_with?('>')

        ' ' * m[1].length
      end

      def self.reflow_text_line(line, mono_block_open, length)
        line.strip!
        if mono_block_open || line.start_with?('=>') || line.length < length
          return [line]
        end

        output = []
        prefix = reflow_line_prefix(line)
        limit_chars = ['-', '­', ' '].freeze
        while line.length > length
          cut_line = line[0...length]
          cut_index = limit_chars.map { cut_line.rindex(_1) || -1 }.max
          break if cut_index.zero? # Better do nothing for now

          output << line[0...cut_index]
          line = prefix + line[cut_index + 1..]
        end
        output << line
      end

      def self.format_body(body, length)
        new_body = []
        mono_block_open = false
        body.each_line do |line|
          if line.start_with?('```')
            mono_block_open = !mono_block_open
            # Don't include code block toggle lines
            next
          end
          new_body += reflow_text_line(line, mono_block_open, length)
        end
        new_body.join("\n")
      end
    end
  end
end
