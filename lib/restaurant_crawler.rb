require "restaurant_crawler/version"
require "restaurant_crawler/restaurant"
require 'anemone'

module RestaurantCrawler

  RESTOPOLITAN_URL = 'http://www.restopolitan.com'

  def self.crawl
    Anemone.crawl(RESTOPOLITAN_URL) do |anemone|
      anemone.on_pages_like(/.*\/restaurant\/.*/) do |page|
        begin
          restaurant = Restaurant.new page.doc
          puts "[x] " + restaurant.to_s
        rescue RuntimeError => e
          puts "[ ] #{e} : #{page.url} craweld"
        end
      end
    end
  end

end
