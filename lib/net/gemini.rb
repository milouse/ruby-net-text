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
  # This will also require 'uri' so you don't need to require it
  # separately.
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
  # The lang, charset and format headers will only be provided in case
  # of `text/*` mimetype, and only if body for 2* status codes.
  #
  #   # Body
  #   puts res.body if res.body_permitted?
  #   puts res.body(reflow_at: 85)
  #
  # When the response is `text/gemini` mimetype, the body is parsed automatically
  # unless you call {Response#read_body} with a block.
  # You can then access links and preformatted blocks found in the body.
  #
  #   res.links # => [{ :uri => #<URI::Gemini gemini://...>, :label => "..." }, ...]
  #   res.preformatted_blocks # => [{ :meta => "...", :content => "..." }, ...]
  #
  # ==== Large Response
  #
  # You may not want to load the whole body of a large response such as
  # images, videos, etc. into memory.
  # You can read response body as chunks.
  #
  #   File.open 'image.png', 'wb' do |f|
  #     Net::Gemini.get_response(URI('gemini://exmaple.org/image.png')) do |res|
  #       res.read_body do |chunk|
  #         f.write chunk
  #       end
  #     end
  #   end
  #
  # You can parse the response body using {Text::GmiParser} when the mimetype is 'text/gemini',
  # though the body is not parsed automatically when {Response#read_body} is called with a block.
  #
  #   if res.meta == 'text/gemini'
  #     body = File.read('path/to/saved/body')
  #     parser = Net::Text::GmiParser.new(base_uri: 'gemini://...')
  #     parser.parse(body)
  #     parser.links # => [{ :uri => #<URI::Gemini gemini://...>, :label => "..." }, ...]
  #     parser.preformatted_blocks # => [{ :meta => "...", :content => "..." }, ...]
  #   end
  #
  # === Following Redirection
  #
  # The {Client#fetch} method, contrary to the {Client#request} one will try
  # to automatically resolves redirection, leading you to the final
  # destination.
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
  module Gemini; end
end

require_relative 'gemini/client'
