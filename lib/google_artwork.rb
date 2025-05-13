require_relative 'google_artwork/version'
require_relative 'google_artwork/parser'

module GoogleArtwork
  class Configuration
    attr_accessor :default_root_url

    def initialize
      @default_root_url = 'https://www.google.com'
    end
  end

  module_function

  def parse(html, root_url: config.default_root_url)
    ::GoogleArtwork::Parser.new(root_url:).call(html)
  end

  def config
    @config ||= Configuration.new
  end

  def configure
    yield(config)
  end
end
