require_relative 'google_artwork/version'
require_relative 'google_artwork/parser'

module GoogleArtwork
  module_function

  def parse_to_hash(html, root_url: 'https://www.google.com')
    artworks = ::GoogleArtwork::Parser.new(root_url:).call(html)
    {
      artworks: artworks.map(&:serialize)
    }
  end
end
