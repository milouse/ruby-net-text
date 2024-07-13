# frozen_string_literal: true

require_relative '../../lib/uri/nex'

describe URI::Nex do
  it 'generates a URI::Nex' do
    expect(URI('nex://nightfall.city/nex/info/specification.txt')).to \
      be_an_instance_of(described_class)
  end

  it 'parses nex official specification', :aggregate_failures do
    u = URI('nex://nightfall.city/nex/info/specification.txt')
    expect(u.host).to eq('nightfall.city')
    expect(u.path).to eq('/nex/info/specification.txt')
  end

  it 'parses nex://nightfall.city', :aggregate_failures do
    u = URI('nex://nightfall.city')
    expect(u.host).to eq('nightfall.city')
    expect(u.path).to eq('')
  end
end
