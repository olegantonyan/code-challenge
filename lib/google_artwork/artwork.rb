module GoogleArtwork
  Artwork = ::Data.define(:name, :link, :thumbnail, :year) do
    def serialize
      h = { name: }
      h[:extensions] = [year] if year&.length&.positive?
      h[:link] = link
      h[:image] = thumbnail
      h.freeze
    end
  end

  class Artworks < ::Array
    def serialize
      {
        artworks: map(&:serialize)
      }.freeze
    end
  end
end
