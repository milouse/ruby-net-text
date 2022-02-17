# frozen_string_literal: true

require_relative '../../lib/uri/gopher'

describe URI::Gopher do
  it 'generates a URI::Gopher' do
    expect(URI('gopher://thelambdalab.xyz/1/')).to \
      be_an_instance_of(described_class)
  end

  it 'parses gopher://thelambdalab.xyz/1/projects/elpher' do
    u = URI('gopher://thelambdalab.xyz/1/projects/elpher')
    expect(u.host).to eq('thelambdalab.xyz')
    expect(u.selector).to eq('/projects/elpher')
    expect(u.item_type).to eq('1')
  end
end
