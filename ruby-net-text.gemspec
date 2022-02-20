# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'ruby-net-text'
  s.version     = '0.0.6'
  s.summary     = 'Gemini, Gopher, and Finger support for Net::* and URI::*'
  s.authors     = ['Étienne Deparis']
  s.email       = 'etienne@depar.is'
  s.metadata    = {
    'rubygems_mfa_required' => 'true',
    'source_code_uri' => 'https://git.umaneti.net/ruby-net-text',
    'funding_uri' => 'https://liberapay.com/milouse'
  }
  s.files       = ['lib/net/gemini/gmi_parser.rb',
                   'lib/net/gemini/request.rb',
                   'lib/net/gemini/response.rb',
                   'lib/net/gemini/ssl.rb',
                   'lib/net/gemini/reflow_text.rb',
                   'lib/net/gemini.rb',
                   'lib/uri/finger.rb',
                   'lib/uri/gemini.rb',
                   'lib/uri/gopher.rb',
                   # Others
                   'LICENSE']
  s.homepage    = 'https://git.umaneti.net/ruby-net-text/'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.7'
end
