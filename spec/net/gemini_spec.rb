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
end
