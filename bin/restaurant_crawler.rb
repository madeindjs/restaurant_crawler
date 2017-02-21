#!/usr/bin/env ruby

require "restaurant_crawler"
require "optparse"

# Parse options
OptionParser.new do |opts|
  opts.on("-c", "--crawl", "Start to crawl restopolitan.com") { RestaurantCrawler.crawl }
  opts.on("-e", "--email", "Start to fetch email from database (need to run crawl before)") { |x| options[:url] = x}
end.parse!