# frozen_string_literal: true

module Gemini
  # Contains specific method to correctly display Gemini texts
  module ReflowText
    private

    def reflow_line_cut_index(line)
      possible_cut = [
        line.rindex(' ') || 0,
        line.rindex('­') || 0,
        line.rindex('-') || 0
      ].sort
      possible_cut.reverse!
      possible_cut[0]
    end

    def reflow_line_prefix(line)
      m = line.match(/\A([*#>]+ )/)
      return '' unless m
      # Each quote line should begin with the quote mark
      return m[1] if m[1].start_with?('>')
      ' ' * m[1].length
    end

    def reflow_text_line(line, mono_block_open, length)
      line.strip!
      if mono_block_open || line.start_with?('=>') || line.length < length
        return [line]
      end
      output = []
      prefix = reflow_line_prefix(line)
      while line.length > length
        cut_line = line[0...length]
        cut_index = reflow_line_cut_index(cut_line)
        break if cut_index.zero? # Better do nothing for now
        output << line[0...cut_index]
        line = prefix + line[cut_index + 1..]
      end
      output << line
    end

    def reformat_body(length)
      unless length.is_a? Integer
        raise ArgumentError, "Length must be Integer, #{length} given"
      end
      return @body if length.zero?
      new_body = []
      mono_block_open = false
      buf = StringIO.new(@body)
      while (line = buf.gets)
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
