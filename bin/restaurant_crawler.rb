#!/usr/bin/env ruby

require "restaurant_crawler"
require "optparse"

# Parse options
OptionParser.new do |opts|
  opts.on("-a", "--crawl_restopolitan", "Start to crawl restopolitan.com")                              { RestaurantCrawler.crawl_restopolitan }
  opts.on("-b", "--crawl_pagesjaunes_restaurants", "Crawl basics restaurants data from pagesjaunes.fr") { RestaurantCrawler.crawl_pagesjaunes }
  opts.on("-c", "--crawl_pagesjaunes_data", "Fetch all restaurants informations from pagesjaunes.fr")   { RestaurantCrawler.crawl_pagesjaunes }
  opts.on("-Z", "--email", "Start to fetch email from websites founded (need to run crawl before)")     { RestaurantCrawler.find_emails }
end.parse!