# frozen_string_literal: true

require 'uri'

module URI
  #
  # The syntax of Gopher URIs is defined in the Gopher URI Scheme
  #   specification[1].
  #
  # [1] https://www.rfc-editor.org/rfc/rfc4266.html
  #
  class Gopher < HTTP
    # A Default port of 70 for URI::Gopher.
    DEFAULT_PORT = 70

    # An Array of the available components for URI::Gopher.
    COMPONENT = %i[
      scheme
      host port
      path
    ].freeze
  end

  @@schemes['GOPHER'] = Gopher
end
