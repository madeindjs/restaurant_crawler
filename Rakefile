require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "restaurant_crawler"


RSpec::Core::RakeTask.new(:spec)

task :default => :spec


desc "start crawler"
task :crawl do
  RestaurantCrawler.crawl
end