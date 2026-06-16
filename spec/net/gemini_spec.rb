# frozen_string_literal: true

require_relative '../../lib/net/gemini'

describe Net::Gemini do
  it 'gets gemini content' do
    f = described_class.get 'gemini://geminiprotocol.net/docs/specification.gmi'
    # We know what we should get
    lines = f.chomp.split("\n")
    expect(lines.first).to eq('# Project Gemini specifications')
  end

  it 'raises an error on non-gemini URI' do
    expect { described_class.get 'https://etienne.depar.is' }.to \
      raise_error(ArgumentError, 'uri is not a String, nor an URI::Gemini')
  end

  # TODO: Actually test against an URI with no metadata (no status?)
  # it 'does not raise with empty metadata', :aggregate_failures do
  #   expect { described_class.get 'gemini://tilde.pink' }.not_to raise_error
  #   res = described_class.get_response URI('gemini://tilde.pink')
  #   expect(res.meta).to be_nil
  # end

  it 'parses body links', :aggregate_failures do
    res = described_class.get_response URI('gemini://geminiprotocol.net/docs/gemtext-specification.gmi')
    expect(res.links.length).to eq 2
    expect(res.links.first).to(
      eq(
        { uri: URI('https://creativecommons.org/publicdomain/zero/1.0/'),
          label: 'Creative Commons CC0 1.0 Universal Public Domain Dedication' }
      )
    )
  end

  it 'yields response chunks' do
    described_class.get_response(URI('gemini://geminiprotocol.net/docs/specification.gmi')) do |res|
      expect { |block| res.read_body(&block) }.to yield_control.at_least(1)
    end
  end
end
