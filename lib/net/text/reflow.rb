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

      def self.reflow_line(line, length)
        output = []
        prefix = reflow_line_prefix(line)
        limit_chars = ['-', '­', ' '].freeze
        while line.length > length
          # Detect first possible cut
          cut_index = limit_chars.map { line[0...length].rindex(_1) || -1 }.max
          break if cut_index.zero? # Better do nothing for now

          output << line[0...cut_index]
          line = prefix + line[(cut_index + 1)..]
        end
        output << line
      end

      def self.parse_line(line, mono_block_open, length)
        if line.start_with?('```')
          mono_block_open = !mono_block_open
          return [mono_block_open, [line.chomp]]
        end

        return [mono_block_open, [line.chomp]] if mono_block_open

        line.strip!
        if line.start_with?('=>') || line.length < length
          return [mono_block_open, [line]]
        end

        [mono_block_open, reflow_line(line, length)]
      end

      def self.format_body(body, length)
        new_body = []
        mono_block_open = false
        body.each_line do |line|
          mono_block_open, content = parse_line line, mono_block_open, length
          new_body += content
        end
        new_body.join("\n")
      end
    end
  end
end
