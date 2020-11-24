# frozen_string_literal: true

require 'uri'

module URI # :nodoc:
  #
  # The syntax of Gopher URIs is defined in the Gopher URI Scheme
  # specification.
  #
  # @see https://www.rfc-editor.org/rfc/rfc4266.html
  #
  class Gopher < HTTP
    # A Default port of 70 for URI::Gopher.
    DEFAULT_PORT = 70

    # An Array of the available components for URI::Gopher.
    COMPONENT = [:scheme, :host, :port, :path].freeze

    def selector
      return @selector if defined? @selector
      @selector = extract_gopher_path_elements[1]
    end

    def item_type
      return @item_type if defined? @item_type
      @item_type = extract_gopher_path_elements[0]
    end

    private

    def extract_gopher_path_elements
      m = /\A\/([0-9+dfghisA-LT])(\/.*)?\Z/.match(@path)
      m.captures
    end
  end

  @@schemes['GOPHER'] = Gopher
end
