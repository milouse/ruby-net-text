# frozen_string_literal: true

require 'uri'

module URI # :nodoc:
  #
  # The syntax of Nex URIs is defined in the Nex specification,
  # section 1.2.
  #
  # @see https://gemini.circumlunar.space/docs/specification.html
  #
  class Nex < HTTP
    # A Default port of 1900 for URI::Nex.
    DEFAULT_PORT = 1900

    # An Array of the available components for URI::Nex.
    COMPONENT = %i[scheme host port path].freeze
  end

  if respond_to? :register_scheme
    # Introduced somewhere in ruby 3.0.x
    register_scheme 'NEX', Nex
  else
    @@schemes['NEX'] = Nex
  end
end
