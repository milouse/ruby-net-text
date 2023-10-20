# Finger, Gemini and Gopher support for Net::* and URI::*

[![Support using Liberapay](https://img.shields.io/badge/Liberapay-Support_me-yellow?logo=liberapay)](https://liberapay.com/milouse/donate)
[![Support using Flattr](https://img.shields.io/badge/Flattr-Support_me-brightgreen?logo=flattr)](https://flattr.com/@milouse)
[![Support using Paypal](https://img.shields.io/badge/Paypal-Support_me-00457C?logo=paypal&labelColor=lightgray)](https://paypal.me/milouse)

[![Gem](https://img.shields.io/gem/v/ruby-net-text)](https://rubygems.org/gems/ruby-net-text)
[![Documentation](https://img.shields.io/badge/Documentation-ruby--net--text-CC342D?logo=rubygems)](https://www.rubydoc.info/gems/ruby-net-text/)

This project aims to add connectors to well known internet text protocols
through the standard `Net::*` and `URI::*` ruby module namespaces.

## News

### Version 0.0.9 gemini breaking changes

This new version changes the Gemini namespace. Everything is now under the
same `Net::Gemini` namespace. If you just used this gem as per the
documentation, nothing changes for you. However, if you were using some hidden
part of the Gemini API, you will probably have to make some changes.

Here are all the changes:

| Old names              | New names                                                                |
|------------------------|--------------------------------------------------------------------------|
| Net::GeminiRequest     | Net::Gemini::Request (still 'net/gemini/request')                        |
| Net::GeminiBadRequest  | Net::Gemini::BadRequest (require 'net/gemini/error')                     |
| Net::GeminiResponse    | Net::Gemini::Response (still 'net/gemini/response')                      |
| Net::GeminiBadResponse | Net::Gemini::BadResponse (require 'net/gemini/error')                    |
| Net::GeminiError       | Net::Gemini::Error (require 'net/gemini/error')                          |
| Net::Gemini.new        | Net::Gemini::Client.new (directly required as part of 'net/gemini')      |
| Gemini::ReflowText     | Net::Text::Reflow (no more expected to be included, but directly called) |
| Gemini::GmiParser      | - (directly integrated into Net::Gemini::Response)                       |
| Gemini::SSL            | - (directly integrated into Net::Gemini::Client)                         |

## Documentation

The code is self-documented and you can browse it on rubydoc.info:

### Finger

- [URI::Finger](https://www.rubydoc.info/gems/ruby-net-text/URI/Finger)
- [Net::Finger](https://www.rubydoc.info/gems/ruby-net-text/Net/Finger)

### Gemini

- [URI::Gemini](https://www.rubydoc.info/gems/ruby-net-text/URI/Gemini)
- [Net::Gemini](https://www.rubydoc.info/gems/ruby-net-text/Net/Gemini)

### Gopher

- [URI::Gopher](https://www.rubydoc.info/gems/ruby-net-text/URI/Gopher)
- [Net::Gopher](https://www.rubydoc.info/gems/ruby-net-text/Net/Gopher)

## Helpers

This repository also includes 2 little helpers:

- `bin/heraut`: a toy client for Finger, Gemini and Gopher. Give it a URI and
  it will output the remote file.
- `bin/test_thread.rb`: a toy performance test script to run against a Gemini
  server
