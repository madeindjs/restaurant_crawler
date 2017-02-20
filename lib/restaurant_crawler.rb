require "restaurant_crawler/version"
require 'anemone'

module RestaurantCrawler

  RESTOPOLITAN_URL = 'http://www.restopolitan.com'

  def self.crawl
    Anemone.crawl(RESTOPOLITAN_URL) do |anemone|
      anemone.on_pages_like(/.*\/restaurant\/.*/) do |page|
          puts page.url
      end
    end
  end

end
