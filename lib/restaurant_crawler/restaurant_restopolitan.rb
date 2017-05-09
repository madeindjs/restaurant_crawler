require 'nokogiri'

module RestaurantCrawler

  class RestaurantRestopolitan < Restaurant
    URL = 'http://www.restopolitan.com'

    def self.from_nokogir_doc nokogiri_doc
      restaurant = RestaurantRestopolitan.new
      # found name
      if h1 = nokogiri_doc.at_css("h1")
        restaurant.name = sanitize h1.text
      else
        raise RuntimeError.new "T"
      end
      # found website
      nokogiri_doc.css("a").each do |link|
        if link.text.include? "Site du restaurant"
          restaurant.website = sanitize link['href']
          break
        end
      end

      raise RuntimeError.new "Restaurant's website not found" unless restaurant.website

      # found address
      if p = nokogiri_doc.at_css("div.addressInfo")
        restaurant.address = sanitize p.text.split('Cuisine').first
      else
        raise RuntimeError.new "Restaurant's address not found"
      end

      return restaurant
    end

  end

end