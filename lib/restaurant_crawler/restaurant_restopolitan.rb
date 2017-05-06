require 'nokogiri'

require 'restaurant'

module RestaurantCrawler

  class RestaurantRestopolitan < Restaurant

    def initialize nokogiri_doc
      @doc = nokogiri_doc
      # found name
      if h1 = @doc.at_css("h1")
        @name = sanitize h1.text
      else
        raise RuntimeError.new "T"
      end
      # found website
      @doc.css("a").each do |link|
        if link.text.include? "Site du restaurant"
          @website = sanitize link['href']
          break
        end
      end

      raise RuntimeError.new "Restaurant's website not found" unless @website

      # found address
      if p = @doc.at_css("div.addressInfo")
        @address = sanitize p.text.split('Cuisine').first
      else
        raise RuntimeError.new "Restaurant's address not found"
      end
    end

  end

end