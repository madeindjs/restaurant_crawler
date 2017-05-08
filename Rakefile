require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "restaurant_crawler"


RSpec::Core::RakeTask.new(:spec)

task :default => :spec


desc "start crawler on restopolitan.com"
task :crawl_restopolitan do
  RestaurantCrawler.crawl_restopolitan
end

desc "Crawl basics restaurants data from pagesjaunes.fr"
task :crawl_pagesjaunes_restaurants do
  RestaurantCrawler.crawl_pagesjaunes_restaurants
end

desc "Fetch all restaurants informations from pagesjaunes.fr"
task :crawl_pagesjaunes_data do
  RestaurantCrawler.fetch_pagesjaunes_data
end


desc "find emails of restaurants crawled"
task :find_emails do
  RestaurantCrawler.find_emails
end