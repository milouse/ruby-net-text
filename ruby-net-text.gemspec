# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'ruby-net-text'
  s.version     = '0.0.9'
  s.summary     = 'Finger, Gemini and Gopher support for Net::* and URI::*'
  s.authors     = ['Étienne Deparis']
  s.email       = 'etienne@depar.is'
  s.metadata    = {
    'rubygems_mfa_required' => 'true',
    'source_code_uri' => 'https://git.umaneti.net/ruby-net-text/',
    'documentation_uri' => 'https://www.rubydoc.info/gems/ruby-net-text',
    'funding_uri' => 'https://liberapay.com/milouse'
  }
  s.homepage    = 'https://git.umaneti.net/ruby-net-text/'
  s.license     = 'MIT'
  s.files       = ['lib/net/gemini/gmi_parser.rb',
                   'lib/net/gemini/request.rb',
                   'lib/net/gemini/response.rb',
                   'lib/net/gemini/ssl.rb',
                   'lib/net/gemini/reflow_text.rb',
                   'lib/net/finger.rb',
                   'lib/net/gemini.rb',
                   'lib/net/gopher.rb',
                   'lib/net/generic.rb',
                   'lib/uri/finger.rb',
                   'lib/uri/gemini.rb',
                   'lib/uri/gopher.rb',
                   # Others
                   'README.md',
                   'LICENSE']

  s.required_ruby_version = '>= 2.7'
end
