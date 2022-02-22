# Gemini, Gopher, and Finger support for Net::* and URI::*

[![Support using Liberapay](https://img.shields.io/badge/Liberapay-Support_me-yellow?logo=liberapay)](https://liberapay.com/milouse/donate)
[![Support using Flattr](https://img.shields.io/badge/Flattr-Support_me-brightgreen?logo=flattr)](https://flattr.com/@milouse)
[![Support using Paypal](https://img.shields.io/badge/Paypal-Support_me-00457C?logo=paypal&labelColor=lightgray)](https://paypal.me/milouse)

[![Gem](https://img.shields.io/gem/v/ruby-net-text)](https://rubygems.org/gems/ruby-net-text)
[![Documentation](https://img.shields.io/badge/Documentation-ruby--net--text-CC342D?logo=rubygems)](https://www.rubydoc.info/gems/ruby-net-text/Net/Gemini)

This project aims to add connectors to well known internet text protocols
through the standard `Net::*` and `URI::*` ruby module namespaces.

## Documentation

The code is self-documented and you can browse it on rubydoc.info:

### Gemini

- [URI::Gemini](https://www.rubydoc.info/gems/ruby-net-text/URI/Gemini)
- [Net::Gemini](https://www.rubydoc.info/gems/ruby-net-text/Net/Gemini)

### Gopher

- [URI::Gopher](https://www.rubydoc.info/gems/ruby-net-text/URI/Gopher)
- [Net::Gopher](https://www.rubydoc.info/gems/ruby-net-text/Net/Gopher)

### Finger

- [URI::Finger](https://www.rubydoc.info/gems/ruby-net-text/URI/Finger)
- [Net::Finger](https://www.rubydoc.info/gems/ruby-net-text/Net/Finger)

## Helpers

This repository also includes 2 little helpers:

- `bin/heraut`: a toy client for Gemini, Gopher and Finger. Give it a URI and
  it will output the remote file.
- `bin/test_thread.rb`: a toy performance test script to run against a Gemini
  server
