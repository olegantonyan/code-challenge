require 'nokogiri'
require 'uri'

require_relative 'artwork'

module GoogleArtwork
  class Parser
    def initialize(root_url:)
      @root_url = ::URI.parse(root_url)
    end

    def call(html)
      document = Nokogiri::HTML5(html)
      extract_artworks(document)
    end

    private

    attr_reader :root_url

    def extract_artworks(document)
      thumbnails_from_js = js_images(document)

      document.xpath('//div[@role="main"]//a[contains(@href, "/search?")][img]').filter_map do |a|
        img = a.at_xpath('./img')

        ::GoogleArtwork::Artwork.new(
          name: a.at_css('.pgNMRc')&.text,
          year: a.at_css('.cxzHyb')&.text,
          link: build_uri(a['href']),
          thumbnail: build_uri(thumbnails_from_js.fetch(img['id'], img['data-src']))
        )
      end
    end

    def js_images(document)
      document.xpath('//div[@role="main"]//script').each_with_object({}) do |elem, acc|
        base64 = elem.text[/var\s+s='([^']+)'/, 1]
        id = elem.text[/var\s+ii=\['([^']+)'/, 1]

        acc[id] = %("#{base64}").undump if base64 && id
      end.freeze
    end

    def build_uri(uri)
      uri = ::URI.parse(uri)
      return uri if uri.host

      ::URI.join(root_url, uri)
    end
  end
end
