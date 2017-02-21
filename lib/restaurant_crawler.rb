require "restaurant_crawler/version"
require "restaurant_crawler/restaurant"
require 'sqlite3'
require 'anemone'

module RestaurantCrawler

  RESTOPOLITAN_URL = 'http://www.restopolitan.com'

  def self.crawl
    database = SQLite3::Database.new "restaurants.sqlite3"
    Anemone.crawl(RESTOPOLITAN_URL, delay: 0.5) do |anemone|
      anemone.on_pages_like(/.*\/restaurant\/.*/) do |page|
        begin
          restaurant = Restaurant.new page.doc
          if restaurant.save database
            puts "[x] " + restaurant.to_s + " saved"
          else
            puts "[ ] failed to save " + restaurant.to_s
          end
        rescue RuntimeError => e
          puts "[ ] #{e} : #{page.url} craweld"
        end
      end
    end
  end

end
