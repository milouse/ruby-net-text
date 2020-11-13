# frozen_string_literal: true

require 'uri'

module URI
  #
  # The syntax of Gemini URIs is defined in the Gemini specification[1],
  #   section 1.2.
  #
  # [1] https://gemini.circumlunar.space/docs/specification.html
  #
  class Gemini < HTTP
    # A Default port of 1965 for URI::Gemini.
    DEFAULT_PORT = 1965

    # An Array of the available components for URI::Gemini.
    COMPONENT = %i[
      scheme
      host port
      path
      query fragment
    ].freeze
  end

  @@schemes['GEMINI'] = Gemini
end
