# frozen_string_literal: true

require 'uri'

module URI # :nodoc:
  #
  # The syntax of Finger URIs is defined in the Finger specification,
  # section 2.3.
  #
  # @see https://tools.ietf.org/html/rfc1288#section-2.3
  #
  class Finger < HTTP
    # A Default port of 79 for URI::Finger.
    DEFAULT_PORT = 79

    # An Array of the available components for URI::Finger.
    COMPONENT = [:scheme, :userinfo, :host, :port, :path].freeze

    def name
      # Utilitary method to extract a name to query, either from the userinfo
      # part or from the path.
      return @user if @user
      return '' unless @path
      # Remove leading /
      @path[1..] || ''
    end
  end

  @@schemes['FINGER'] = Finger
end
