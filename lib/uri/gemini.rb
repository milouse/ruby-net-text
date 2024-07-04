# frozen_string_literal: true

require 'uri'

module URI # :nodoc:
  #
  # The syntax of Gemini URIs is defined in the Gemini specification,
  # section 1.2.
  #
  # @see https://gemini.circumlunar.space/docs/specification.html
  #
  class Gemini < HTTP
    # A Default port of 1965 for URI::Gemini.
    DEFAULT_PORT = 1965

    # An Array of the available components for URI::Gemini.
    COMPONENT = %i[scheme host port path query fragment].freeze
  end

  if respond_to? :register_scheme
    # Introduced somewhere in ruby 3.0.x
    register_scheme 'GEMINI', Gemini
  else
    @@schemes['GEMINI'] = Gemini
  end
end
