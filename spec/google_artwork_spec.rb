require 'spec_helper'
require 'json'

describe ::GoogleArtwork do
  subject do
    ::JSON.pretty_generate(described_class.parse(load_test_html('van-gogh-paintings.html')).serialize)
  end

  it { is_expected.to eq(load_test_output('expected-array.json')) }

  describe 'page with images' do
    subject do
      described_class.parse(load_test_html('hellhammer photos - Google Search.html')).serialize
    end

    it do
      art = subject.dig(:artworks, 0)
      expect(art[:name]).to eq('Hellhammer - Wikipedia')
      expect(art[:link]).to eq('https://en.wikipedia.org/wiki/Hellhammer')
      expect(art[:image].to_s).to start_with('data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD')
    end
  end
end
