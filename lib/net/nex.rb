# frozen_string_literal: true

require_relative '../uri/nex'
require_relative 'text/generic'

module Net
  # == A Nex client API for Ruby.
  #
  # Net::Nex provides a library which can be used to build Nex
  # user-agents.
  #
  # Net::Nex is designed to work closely with URI.
  #
  # == Simple Examples
  #
  # All examples assume you have loaded Net::Nex with:
  #
  #   require 'net/nex'
  #
  # This will also require 'uri' so you don't need to require it
  # separately.
  #
  # The Net::Nex methods in the following section do not persist
  # connections.
  #
  # === GET by URI
  #
  #   uri = URI('nex://nightfall.city/nex/info/')
  #   Net::Nex.get(uri) # => String
  #
  class Nex < Text::Generic
    def self.get(string_or_uri)
      uri = build_uri string_or_uri, URI::Nex
      request uri, "#{uri.path}\r\n"
    end
  end
end
