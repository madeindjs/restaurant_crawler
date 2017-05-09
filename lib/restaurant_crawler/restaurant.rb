require 'sqlite3'

module RestaurantCrawler


  class Restaurant
    attr_accessor :id, :name, :website, :address, :telephone, :email, :yellow_id, :yellow_province

    def self.from_sql_hash sql_data
      restaurant = self.new
      restaurant.id        = sql_data['id']
      restaurant.name      = sql_data['name']
      restaurant.website   = sql_data['website']
      restaurant.yellow_id = sql_data['yellow_id']
      restaurant.yellow_province = sql_data['yellow_province'] 
      restaurant.email     = sql_data['email'] if sql_data.has_key? 'email'
      restaurant.telephone = sql_data['telephone'] if sql_data.has_key? 'telephone'
      return restaurant
    end


    def to_s
      "#{@name}: #{@website}"
    end


    def save database
      database.execute """CREATE TABLE IF NOT EXISTS restaurants(
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        website TEXT, 
        telephone TEXT, 
        address TEXT,
        yellow_province TEXT,
        yellow_id INTEGER 
      )"""
      if @id
        stm = database.prepare """
          UPDATE restaurants 
          SET name = :name , website = :website, address = :address, telephone = :telephone, yellow_province = :yellow_province, yellow_id = :yellow_id
          WHERE id = :id
        """
        stm.bind_param 'id', @id
      else
        stm = database.prepare """
          INSERT INTO restaurants(name, website, address, yellow_id, telephone, yellow_province) 
          VALUES(:name, :website, :address, :yellow_id, :telephone, :yellow_province)
        """
      end
      stm.bind_param 'name', @name
      stm.bind_param 'website', @website
      stm.bind_param 'address', @address
      stm.bind_param 'telephone', @telephone
      stm.bind_param 'yellow_id', @yellow_id
      stm.bind_param 'yellow_province', @yellow_province
      begin
        stm.execute
        return true
      rescue Exception => e
        return false
      end
    end


    private

    def sanitize string
      string.gsub!("\n", '')
      string.gsub!("\r", '')
      string.gsub!("  ", '')
      return string
    end
    
  end

end