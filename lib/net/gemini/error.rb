# frozen_string_literal: true

module Net
  module Gemini
    class Error < StandardError; end
    class BadRequest < Error; end
    class BadResponse < Error; end
  end
end
