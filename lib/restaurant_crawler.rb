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

  @database = SQLite3::Database.new "restaurants.sqlite3"
  @database.results_as_hash = true

  

  def self.crawl_restopolitan
    Anemone.crawl(RestaurantRestopolitan::URL, delay: 0.5) do |anemone|
      anemone.on_pages_like(/.*\/restaurant\/.*/) do |page|
        begin
          restaurant = RestaurantRestopolitan.from_nokogiri_doc page.doc
          if restaurant.save @database
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


  def self.crawl_pagesjaunes_restaurants
    RestaurantPagesjaunes.restaurants do |restaurant|
      if restaurant.save @database
        puts "[x] " + restaurant.to_s + " saved"
      else
        puts "[ ] failed to save " + restaurant.to_s
      end
    end
  end

  def self.fetch_pagesjaunes_data
    # get only restaurants from yellow API and with website empty
    @database.execute("SELECT * FROM restaurants WHERE yellow_id IS NOT NULL AND website = '?'").each do |row|
      restaurant = RestaurantPagesjaunes.from_sql_hash(row)
      restaurant.fetch_yellow_informations
      if restaurant.save @database
        puts "[x] found information about " + restaurant.to_s
      else
        puts "[ ] not found information about " + restaurant.to_s
      end
      sleep 2
    end
  end

  def self.find_emails
    # add columns if needed
    ['email', 'telephone', 'error'].each do |column|
      @database.execute "ALTER TABLE restaurants ADD COLUMN #{column} TEXT" rescue SQLite3::SQLException
    end


    @database.execute("SELECT * FROM restaurants").each do |row|
      Restaurant.from_sql_hash id = row

      begin
        doc = Nokogiri::HTML(open website)
        # get all link
        doc.css('a').each do |link|
          # get mailto / telto
          email     = link['href'] if link['href'].include? 'mailto:'
          telephone = link['href'] if link['href'].include? 'telto:'
        end

        if email || telephone
          stm = @database.prepare "UPDATE restaurants SET email = :email, telephone = :telephone WHERE id = :id"
          stm.bind_param 'id', id
          stm.bind_param 'email', email
          stm.bind_param 'telephone', telephone
          stm.execute 
          puts "[x] #{name} => #{email} / #{telephone}"
        else
          raise RuntimeError.new "Restaurant's email / telephone not found"
        end
      rescue Exception => e
        stm = @database.prepare "UPDATE restaurants SET error = :error WHERE id = :id"
        stm.bind_param 'id', id
        stm.bind_param 'error', e.message
        stm.execute 
        puts "[ ] #{name} => " + e.message
      end
    end
    database.close
  end

end
