#!/usr/bin/env ruby

require "restaurant_crawler"
require "optparse"

# Parse options
OptionParser.new do |opts|
  opts.on("-r", "--crawl_restopolitan", "Start to crawl restopolitan.com") { RestaurantCrawler.crawl_restopolitan }
  opts.on("-p", "--crawl_pagesjaunes", "Start to crawl pagesjaunes.fr") { RestaurantCrawler.crawl_pagesjaunes }
  opts.on("-e", "--email", "Start to fetch email from websites founded (need to run crawl before)") { |x| options[:url] = x}
end.parse!