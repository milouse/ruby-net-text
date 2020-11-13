# frozen_string_literal: true

require 'uri'

module URI
  #
  # The syntax of Gemini URIs is defined in the Gemini specification[1],
  #   section 1.2.
  #
  # [1] https://gemini.circumlunar.space/docs/specification.html
  #
  class Gemini < Generic
    # A Default port of 1965 for URI::Gemini.
    DEFAULT_PORT = 1965

    # An Array of the available components for URI::Gemini.
    COMPONENT = %i[
      scheme
      host port
      path
      query fragment
    ].freeze

    #
    # == Description
    #
    # Creates a new URI::Gemini object from components, with syntax
    #   checking.
    #
    # The components accepted are host, port, path, query, and fragment.
    #
    # The components should be provided either as an Array, or as a Hash
    # with keys formed by preceding the component names with a colon.
    #
    # If an Array is used, the components must be passed in the
    # order <code>[host, port, path, query, fragment]</code>.
    #
    # Example:
    #
    #     uri = URI::Gemini.build(
    #       host: 'www.example.com', path: '/foo/bar'
    #     )
    #
    #     uri = URI::Gemini.build(
    #       ["www.example.com", nil, "/path", "query", 'fragment']
    #     )
    #
    def self.build(args)
      tmp = Util.make_components_hash(self, args)
      super(tmp)
    end
  end

  @@schemes['GEMINI'] = Gemini
end
