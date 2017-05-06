require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "restaurant_crawler"


RSpec::Core::RakeTask.new(:spec)

task :default => :spec


desc "start crawler"
task :crawl_restopolitan do
  RestaurantCrawler.crawl_restopolitan
end


desc "find emails of restaurants crawled"
task :find_emails do
  RestaurantCrawler.find_emails
end