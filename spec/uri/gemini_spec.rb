# frozen_string_literal: true

require_relative '../../lib/uri/gemini'

describe URI::Gemini do
  it 'generates a URI::Gemini' do
    expect(URI('gemini://gemini.circumlunar.space/docs/specification.gmi')).to \
      be_an_instance_of(described_class)
  end

  it 'parses gemini://gemini.circumlunar.space/docs/specification.gmi' do
    u = URI('gemini://gemini.circumlunar.space/docs/specification.gmi')
    expect(u.host).to eq('gemini.circumlunar.space')
    expect(u.path).to eq('/docs/specification.gmi')
  end
end
