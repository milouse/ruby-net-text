# frozen_string_literal: true

require_relative '../../lib/uri/gemini'

describe URI::Gemini do
  it 'generates a URI::Gemini' do
    expect(URI('gemini://geminiprotocol.net/docs/specification.gmi')).to \
      be_an_instance_of(described_class)
  end

  it 'parses official gemini spec', :aggregate_failures do
    u = URI('gemini://geminiprotocol.net/docs/specification.gmi')
    expect(u.host).to eq('geminiprotocol.net')
    expect(u.path).to eq('/docs/specification.gmi')
  end
end
