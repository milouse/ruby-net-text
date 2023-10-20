# frozen_string_literal: true

require_relative '../../lib/net/nex'

describe Net::Nex do
  it 'get nex content' do
    f = described_class.get 'nex://nightfall.city/nex/info/specification.txt'
    # We know what we should get
    lines = f.strip.split("\n")
    expect(lines[0]).to eq('THE NEX PROTOCOL')
  end

  it 'raises an error on non-nex URI' do
    expect { described_class.get 'https://etienne.depar.is' }.to \
      raise_error(ArgumentError, 'uri is not a String, nor an URI::Nex')
  end
end
