# frozen_string_literal: true

require_relative '../../lib/net/finger'

describe Net::Finger do
  it 'get finger content' do
    f = described_class.get 'finger://skyjake.fi/jaakko'
    # We know what we should get
    lines = f.strip.split("\n")
    expect(lines[0]).to eq('Jaakko\'s .plan')
  end

  it 'does not fail on empty content' do
    f = described_class.get 'finger://skyjake.fi/'
    # We know what we should get
    extract = f.strip.split("\n")[0..3].join('@')
    expect(extract).to eq('SKYJAKE.FI@==========@@Users: jaakko')
  end

  it 'raises an error on non-finger URI' do
    expect { described_class.get 'https://etienne.depar.is' }.to \
      raise_error(ArgumentError, 'uri is not a String, nor an URI::Finger')
  end
end
