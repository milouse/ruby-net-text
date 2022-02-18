# frozen_string_literal: true

require_relative '../uri/finger'
require_relative 'generic'

module Net
  # == A Finger client API for Ruby.
  #
  # Net::Finger provides a library which can be used to build Finger
  # user-agents.
  #
  # Net::Finger is designed to work closely with URI.
  #
  # == Simple Examples
  #
  # All examples assume you have loaded Net::Finger with:
  #
  #   require 'net/finger'
  #
  # This will also require 'uri' so you don't need to require it
  # separately.
  #
  # The Net::Finger methods in the following section do not persist
  # connections.
  #
  # === GET by URI
  #
  #   uri = URI('finger://skyjake.fi/jaakko')
  #   Net::Finger.get(uri) # => String
  #
  class Finger
    extend TextGeneric

    def self.get(string_or_uri)
      uri = build_uri string_or_uri, URI::Finger
      request uri, uri.name.to_s
    end
  end
end
