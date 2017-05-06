require 'sqlite3'

module RestaurantCrawler


  class Restaurant

    attr_reader :doc
    attr_accessor :name, :website, :address


    def to_s
      "#{@name}: #{@website}"
    end


    def save database
      database.execute "CREATE TABLE IF NOT EXISTS restaurants(Id INTEGER PRIMARY KEY, name TEXT, website TEXT, address TEXT)"
      stm = database.prepare "INSERT INTO restaurants(name, website, address) VALUES(:name, :website, :address)"
      stm.bind_param 'name', @name
      stm.bind_param 'website', @website
      stm.bind_param 'address', @address
      stm.execute 
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