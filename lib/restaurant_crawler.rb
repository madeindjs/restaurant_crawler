require "restaurant_crawler/version"
require "restaurant_crawler/restaurant"
require 'sqlite3'
require 'anemone'
require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'

require 'restaurant_crawler/restaurant_restopolitan'
require 'restaurant_crawler/restaurant_pagesjaunes'

module RestaurantCrawler

  

  def self.crawl_restopolitan
    database = SQLite3::Database.new "restaurants.sqlite3"
    Anemone.crawl(RestaurantRestopolitan::URL, delay: 0.5) do |anemone|
      anemone.on_pages_like(/.*\/restaurant\/.*/) do |page|
        begin
          restaurant = RestaurantRestopolitan.new page.doc
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


  def self.crawl_pagesjaunes
    (1..2).each do |page_number|
      # url = RestaurantPagesjaunes.build_url page_number
      # puts url
      RestaurantPagesjaunes.restaurants
    end
  end

  def self.find_emails
    database = SQLite3::Database.new "restaurants.sqlite3"

    # add columns if needed
    ['email', 'telephone', 'error'].each do |column|
      begin
        database.execute "ALTER TABLE restaurants ADD COLUMN #{column} TEXT"
      rescue SQLite3::SQLException
      end
    end


    database.execute("SELECT * FROM restaurants").each do |row|
      id = row[0]
      name = row[1]
      website = row[2]
      email = telephone = nil

      begin
        doc = Nokogiri::HTML(open website)
        # get all link
        doc.css('a').each do |link|
          # get mailto / telto
          email     = link['href'] if link['href'].include? 'mailto:'
          telephone = link['href'] if link['href'].include? 'telto:'
        end

        if email || telephone
          stm = database.prepare "UPDATE restaurants SET email = :email, telephone = :telephone WHERE id = :id"
          stm.bind_param 'id', id
          stm.bind_param 'email', email
          stm.bind_param 'telephone', telephone
          stm.execute 
          puts "[x] #{name} => #{email} / #{telephone}"
        else
          raise RuntimeError.new "Restaurant's email / telephone not found"
        end
      rescue Exception => e
        stm = database.prepare "UPDATE restaurants SET error = :error WHERE id = :id"
        stm.bind_param 'id', id
        stm.bind_param 'error', e.message
        stm.execute 
        puts "[ ] #{name} => " + e.message
      end
    end
    database.close
  end

end
