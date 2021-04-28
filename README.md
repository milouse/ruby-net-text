# Gemini, Gopher, and Finger support for Net::* and URI::*

[![Support using Liberapay](https://img.shields.io/badge/Liberapay-Support_me-yellow?logo=liberapay)](https://liberapay.com/milouse/donate)
[![Support using Flattr](https://img.shields.io/badge/Flattr-Support_me-brightgreen?logo=flattr)](https://flattr.com/@milouse)
[![Support using Paypal](https://img.shields.io/badge/Paypal-Support_me-00457C?logo=paypal&labelColor=lightgray)](https://paypal.me/milouse)

[![Gem](https://img.shields.io/gem/v/ruby-net-text)](https://rubygems.org/gems/ruby-net-text)
[![Documentation](https://img.shields.io/badge/Documentation-ruby--net--text-CC342D?logo=rubygems)](https://www.rubydoc.info/gems/ruby-net-text/Net/Gemini)

This project aims to add connectors to well known internet text protocols
through the standard `Net::*` and `URI::*` ruby module namespaces.

Currently, only Gemini is well supported.

## A Gemini client API for Ruby.

`Net::Gemini` provides a rich library which can be used to build
[Gemini](https://gemini.circumlunar.space/docs/specification.html)
user-agents.

`Net::Gemini` is designed to work closely with `URI`.

All examples bellow assume you have loaded `Net::Gemini` with:

```ruby
require 'net/gemini'
```

This will also require 'uri' so you don't need to require it
separately.

The `Net::Gemini` methods in the following section do not persist
connections (the protocol does not allow it).

### GET by URI

```ruby
uri = URI('gemini://gemini.circumlunar.space/')
Net::Gemini.get(uri) # => String
```

### GET with Dynamic Parameters

```ruby
uri = URI('gemini://gus.guru/search')
uri.query = URI.encode_www_form('test')
res = Net::Gemini.get_response(uri)
puts res.body if res.body_permitted?
```

### Response Data

```ruby
res = Net::Gemini.get_response(URI('gemini://gemini.circumlunar.space/'))
# Status
puts res.status # => '20'
puts res.meta   # => 'text/gemini; charset=UTF-8; lang=en'
# Headers
puts res.header.inspect
# => { status: '20', meta: 'text/gemini; charset=UTF-8',
       mimetype: 'text/gemini', lang: 'en',
       charset: 'utf-8', format: nil }
```

The lang, charset and format headers will only be provided in case
of `text/*` mimetype, and only if body for `2*` status codes.

```ruby
# Body
puts res.body if res.body_permitted?
puts res.body(flowed: 85)
```

### Following Redirection

The `#fetch` method, contrary to the `#request` one will try to
automatically resolves redirection, leading you to the final
destination.

```ruby
u = URI('gemini://exemple.com/redirect')
res = Net::Gemini.start(u.host, u.port) do |g|
  g.request(u)
end
puts "#{res.status} - #{res.meta}" # => '30 final/dest'
puts res.uri.to_s                  # => 'gemini://exemple.com/redirect'
u = URI('gemini://exemple.com/redirect')
res = Net::Gemini.start(u.host, u.port) do |g|
  g.fetch(u)
end
puts "#{res.status} - #{res.meta}" # => '20 - text/gemini;'
puts res.uri.to_s                  # => 'gemini://exemple.com/final/dest'
```
