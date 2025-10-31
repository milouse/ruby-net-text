# frozen_string_literal: true

require_relative '../../lib/net/text/gmi_parser'

describe Net::Text::GmiParser do
  let(:content) { File.read(File.join(__dir__, '../fixtures/gemtext.gmi')) }

  it 'parses gemtext' do
    parser = described_class.new(base_uri: 'gemini://geminiprotocol.net/docs/gemtext.gmi')
    parser.parse(content)
    expect(parser.links).to eq [{ label: 'Gemtext cheatsheet', uri: URI('gemini://geminiprotocol.net/docs/cheatsheet.gmi') }]

    blocks = [
      <<EOS,
=> https://example.com    A cool website
=> gopher://example.com   An even cooler gopherhole
=> gemini://example.com   A supremely cool Gemini capsule
=> sftp://example.com
EOS
      <<EOS,
=>https://example.com A cool website
=>gopher://example.com      An even cooler gopherhole
=> gemini://example.com A supremely cool Gemini capsule
=>   sftp://example.com
EOS
      <<EOS,
# Heading

## Sub-heading

### Sub-sub-heading
EOS
      <<EOS,
* Mercury
* Gemini
* Apollo
EOS
      <<EOS
> Gemtext supports blockquotes.  The quoted content is written as a single long line, which begins with a single > character
EOS
    ]
    expect(parser.preformatted_blocks).to eq blocks.collect {|content| { meta: '', content: content }}
  end
end
