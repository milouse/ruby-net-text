# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'ruby-net-text'
  s.version     = '0.0.9'
  s.summary     = 'Finger, Gemini, Gopher and Nex support for Net::* and URI::*'
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
  s.files       = ['lib/net/finger.rb',
                   'lib/net/gemini/client.rb',
                   'lib/net/gemini/client/ssl.rb',
                   'lib/net/gemini/error.rb',
                   'lib/net/gemini.rb',
                   'lib/net/gemini/request.rb',
                   'lib/net/gemini/response/parser.rb',
                   'lib/net/gemini/response.rb',
                   'lib/net/gopher.rb',
                   'lib/net/nex.rb',
                   'lib/net/text/generic.rb',
                   'lib/net/text/reflow.rb',
                   'lib/uri/finger.rb',
                   'lib/uri/gemini.rb',
                   'lib/uri/gopher.rb',
                   'lib/uri/nex.rb',
                   # Others
                   'README.md',
                   'LICENSE']

  s.post_install_message = <<~POSTINST
    The version 0.0.9 introduces some breaking changes in Gemini support.
    If you were using its internal API instead of just using the documented
    methods, please refer to the README to know more about the changes.

    https://git.umaneti.net/ruby-net-text/about/

  POSTINST

  s.required_ruby_version = '>= 2.7'
end
