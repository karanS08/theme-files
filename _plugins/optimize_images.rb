# Custom plugin to add imagekit optimization to images inside rendered posts

require 'jekyll'
require 'nokogiri'

module Jekyll
  module OptimizeImages

    def config
      @context.registers[:site].config['img_src_prefix']
    end

    def optimize_images(content)
      if ENV['JEKYLL_ENV'] != 'production' || config.nil?
        return content
      end

      doc = Nokogiri::HTML.fragment(content)

      # Stop if we could't parse with HTML
      return content unless doc

      doc.css('img').each do |a|
          a.set_attribute('src', config + a.get_attribute('src'))
      end

      doc.to_s
    end

  end
end

Liquid::Template.register_filter(Jekyll::OptimizeImages)