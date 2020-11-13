# frozen_string_literal: true

require './lib/fronde/version'

Gem::Specification.new do |s|
  s.name        = 'ruby-net-text'
  s.version     = '0.0.1'
  s.summary     = 'Gemini, Gopher, and Finger support for Net::* and URI::*'
  s.authors     = ['Étienne Deparis']
  s.email       = 'etienne@depar.is'
  s.files       = ['lib/net/gemini/response.rb',
                   'lib/net/gemini.rb',
                   'lib/uri/finger.rb',
                   'lib/uri/gemini.rb',
                   'lib/uri/gopher.rb',
                   # Others
                   'LICENSE']
  s.homepage    = 'https://git.umaneti.net/ruby-net-text/'
  s.license     = ['MIT']

  s.required_ruby_version = '>= 2.6'
end
