# frozen_string_literal: true

require_relative '../uri/gopher'
require_relative 'generic'

module Net
  # == A Gopher client API for Ruby.
  #
  # Net::Gopher provides a library which can be used to build Gopher
  # user-agents.
  #
  # Net::Gopher is designed to work closely with URI.
  #
  # == Simple Examples
  #
  # All examples assume you have loaded Net::Gopher with:
  #
  #   require 'net/gopher'
  #
  # This will also require 'uri' so you don't need to require it
  # separately.
  #
  # The Net::Gopher methods in the following section do not persist
  # connections.
  #
  # === GET by URI
  #
  #   uri = URI('gopher://thelambdalab.xyz/1/projects/elpher/')
  #   Net::Gopher.get(uri) # => String
  #
  class Gopher
    extend TextGeneric

    def self.get(string_or_uri)
      uri = build_uri string_or_uri, URI::Gopher
      request uri, "#{uri.selector}\r\n"
    end
  end
end
