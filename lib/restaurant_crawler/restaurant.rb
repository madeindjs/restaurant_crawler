require 'sqlite3'

module RestaurantCrawler


  class Restaurant
    attr_reader :id, :name, :website, :address


    def to_s
      "#{@name}: #{@website}"
    end


    def save database
      database.execute """CREATE TABLE IF NOT EXISTS restaurants(
        id INTEGER PRIMARY KEY, 
        name TEXT UNIQUE, 
        website TEXT, 
        address TEXT,
        yellow_id
      )"""
      stm = database.prepare "INSERT INTO restaurants(name, website, address, yellow_id) VALUES(:name, :website, :address, :yellow_id)"
      stm.bind_param 'yellow_id', @yellow_id
      stm.bind_param 'name', @name
      stm.bind_param 'website', @website
      stm.bind_param 'address', @address
      stm.execute 
      return true
    end


    private

    def sanitize string
      string.gsub!("\n", '')
      string.gsub!("\r", '')
      string.gsub!("  ", '')
      return string
    end


    def fetch_restopolitan
    end

    
  end


end