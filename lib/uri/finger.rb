# frozen_string_literal: true

require 'uri'

module URI # :nodoc:
  #
  # The syntax of Finger URIs is defined in the Finger specification,
  #   section 2.3: https://tools.ietf.org/html/rfc1288#section-2.3
  #
  class Finger < HTTP
    # A Default port of 79 for URI::Finger.
    DEFAULT_PORT = 79

    # An Array of the available components for URI::Finger.
    COMPONENT = [:scheme, :userinfo, :host, :port].freeze
  end

  @@schemes['FINGER'] = Finger
end
