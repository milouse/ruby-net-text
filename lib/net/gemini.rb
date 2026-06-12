# frozen_string_literal: true

# This file is derived from "net/http.rb".

require 'socket'
require 'openssl'
require 'fileutils'

module Net
  # == A Gemini client API for Ruby.
  #
  # Net::Gemini provides a library which can be used to build Gemini
  # user-agents.
  # @see gemini://geminiprotocol.net/docs/specification.gmi
  #
  # Net::Gemini is designed to work closely with URI.
  #
  # == Simple Examples
  #
  # All examples assume you have loaded Net::Gemini with:
  #
  #   require 'net/gemini'
  #
  # This will also require 'uri' so you don't need to require it separately.
  #
  # The Net::Gemini methods in the following section do not persist
  # connections.
  #
  # === GET by URI
  #
  #   Net::Gemini.get('gemini://gemini.circumlunar.space/') # => String
  #
  # === GET with Dynamic Parameters
  #
  #   uri = URI('gemini://gus.guru/search')
  #   uri.query = URI.encode_www_form('test')
  #
  #   res = Net::Gemini.get_response(uri)
  #   puts res.body if res.body_permitted?
  #
  # === Response Data
  #
  #   res = Net::Gemini.get_response(URI('gemini://gemini.circumlunar.space/'))
  #
  #   # Status
  #   puts res.status # => '20'
  #   puts res.meta   # => 'text/gemini; charset=UTF-8; lang=en'
  #
  #   # Headers
  #   puts res.header.inspect
  #   # => { status: '20', meta: 'text/gemini; charset=UTF-8',
  #           mimetype: 'text/gemini', lang: 'en',
  #           charset: 'utf-8', format: nil }
  #
  # The `:lang`, `:charset` and `:format` headers will only be provided in case
  # of `text/*` mimetype, and {Response#body body} only for 2* status codes.
  #
  #   # Body
  #   puts res.body if res.body_permitted?
  #   puts res.body(reflow_at: 85)
  #
  # When the response is `text/gemini` mimetype, the body is parsed
  # automatically to extract all its links.
  #
  #   res.links # => [{ :uri => #<URI::Gemini gemini://…>, :label => "…" }, …]
  #
  # ==== Large Response
  #
  # You may not want to load the whole body of a large response such as images,
  # videos, etc. into memory. To avoid that, you can read response body as
  # chunks.
  #
  #   f = File.new 'image.png', 'wb'
  #   Net::Gemini.get_response(URI('gemini://example.org/image.png')) do |res|
  #     res.read_body { |chunk| f.write chunk }
  #   end
  #   f.close
  #
  # It has to be noted that the block given to the {::get_response} method is
  # executed while the socket is being read. This means the {Response} instance
  # you get as block argument does not have parsed its body in case of
  # a `text/gemini` mimetype, and thus its {Response#links} array will be
  # empty. In any case, {::get_response} returns the {Response} instance, thus
  # if you need access to these links, you must do this:
  #
  #   uri = URI('gemini://example.org/very_long_text.gmi')
  #   res = Net::Gemini.get_response(uri) do |res|
  #     # … do something
  #   end
  #   res.links # => [{ :uri => #<URI::Gemini gemini://…>, :label => "…" }, …]
  #
  # === Following Redirection
  #
  # The {Client#fetch} method, contrary to the {Client#request} one will try to
  # automatically resolves redirection, leading you to the final destination.
  #
  #   u = URI('gemini://exemple.com/redirect')
  #   res = Net::Gemini.start(u.host, u.port) do |g|
  #     g.request(u)
  #   end
  #   puts "#{res.status} - #{res.meta}" # => '30 final/dest'
  #   puts res.uri.to_s                  # => 'gemini://exemple.com/redirect'
  #
  #   u = URI('gemini://exemple.com/redirect')
  #   res = Net::Gemini.start(u.host, u.port) do |g|
  #     g.fetch(u)
  #   end
  #   puts "#{res.status} - #{res.meta}" # => '20 - text/gemini;'
  #   puts res.uri.to_s                  # => 'gemini://exemple.com/final/dest'
  #
  # This fetch method is automatically called by the class methods {::get} and
  # {::get_response}.
  #
  #   res = Net::Gemini.get_response(URI('gemini://exemple.com/redirect'))
  #   puts "#{res.status} - #{res.meta}" # => '20 - text/gemini;'
  #   puts res.uri.to_s                  # => 'gemini://exemple.com/final/dest'
  module Gemini; end
end

require_relative 'gemini/client'
