# frozen_string_literal: true

require_relative '../../lib/uri/finger'

describe URI::Finger do
  it 'generates a URI::Finger' do
    expect(URI('finger://skyjake.fi/jaakko')).to \
      be_an_instance_of(described_class)
  end

  it 'parses finger://skyjake.fi/jaakko', :aggregate_failures do
    u = URI('finger://skyjake.fi/jaakko')
    expect(u.host).to eq('skyjake.fi')
    expect(u.name).to eq('jaakko')
  end

  it 'parses finger://jaakko@skyjake.fi/', :aggregate_failures do
    u = URI('finger://jaakko@skyjake.fi/')
    expect(u.host).to eq('skyjake.fi')
    expect(u.name).to eq('jaakko')
  end

  it 'parses finger://jaakko@skyjake.fi', :aggregate_failures do
    u = URI('finger://jaakko@skyjake.fi')
    expect(u.host).to eq('skyjake.fi')
    expect(u.name).to eq('jaakko')
  end

  it 'parses finger://skyjake.fi', :aggregate_failures do
    u = URI('finger://skyjake.fi')
    expect(u.host).to eq('skyjake.fi')
    expect(u.name).to eq('')
  end
end
