require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "restaurant_crawler"


RSpec::Core::RakeTask.new(:spec)

task :default => :spec


desc "start crawler on restopolitan.com"
task :crawl_restopolitan do
  RestaurantCrawler.crawl_restopolitan
end

desc "start crawler on pages-jaunes.fr"
task :crawl_pagesjaunes do
  RestaurantCrawler.crawl_pagesjaunes
end


desc "find emails of restaurants crawled"
task :find_emails do
  RestaurantCrawler.find_emails
end