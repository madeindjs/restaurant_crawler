require 'json'
require 'nokogiri'
require 'open-uri'


module RestaurantCrawler

  class RestaurantPagesjaunes < Restaurant
    attr_reader :yellow_id

    API_KEY = 'dhwbqeefj7n8swu2d5gea74j'

    # @param yellow_data = {
    #   "id"=>"285103", "name"=>"Canada Drive-In Restaurants Regd", 
    #   "address"=>{"street"=>"1450, av Victoria", "city"=>"Greenfield Park", "prov"=>"QC", "pcode"=>"J4V 1M2"}, 
    #   "geoCode"=>{"latitude"=>"45.488803", "longitude"=>"-73.491364"}, 
    #   "distance"=>"1.3", "parentId"=>"", "isParent"=>false, 
    #   "content"=>{
    #     "Video"=>{"avail"=>false, "inMkt"=>false}, 
    #     "Photo"=>{"avail"=>false, "inMkt"=>false},
    #     "Profile"=>{"avail"=>true, "inMkt"=>true},
    #     "DspAd"=>{"avail"=>false, "inMkt"=>false},
    #     "Logo"=>{"avail"=>false, "inMkt"=>false},
    #     "Url"=>{"avail"=>false, "inMkt"=>false}
    #   }
    #  }
    def self.from_yellow_data yellow_data
      restaurant = RestaurantPagesjaunes.new
      restaurant.yellow_id = yellow_data['id']
      restaurant.name      = yellow_data['name']
      restaurant.website   = '?' if yellow_data['content']['Url']['avail']
      # build address to something like `1450, av Victoria, J4V 1M2, Greenfield Park, ` 
      address              = yellow_data['address']
      restaurant.address   = [ address['street'], address['pcode'], address['city'] ].join(', ')
      restaurant.yellow_province = address['street']['prov']
      return restaurant
    end


    def self.restaurants where = 'Rhone'
      # build URL
      params = {
        what:   'restaurants',
        where:  where,
        UID:    '127.0.0.1',
        apikey: API_KEY,
        pgLen:  140,
        fmt:    'json',
        lang:   'fr',
      }
      url = 'http://api.sandbox.yellowapi.com/FindBusiness/?' + URI.encode_www_form(params)

      # get data from API
      begin
        data = JSON.load(open(url)) 
      rescue OpenURI::HTTPError
        puts "maximum requests limit reached"
        exit!
      end
      pages_count = data['summary']['pageCount'].to_i

      # get restaurants from 1st query
      data['listings'].each do |restaurant_data|
        yield RestaurantPagesjaunes.from_yellow_data restaurant_data 
      end

      # now query others pages
      (2..pages_count).each do |page_number|
        params['pg'] = page_number
        url = 'http://api.sandbox.yellowapi.com/FindBusiness/?' + URI.encode_www_form(params)
        JSON.load(open(url))['listings'].each do |restaurant_data|
          yield RestaurantPagesjaunes.from_yellow_data restaurant_data
        end
        sleep 2 # to not exceed maximum request per seconds allowed  
      end

    end


    def fetch_yellow_informations
      throw RuntimeError.new 'yellow_id is empty' unless @yellow_id
      params = {
        UID:       '127.0.0.1',
        apikey:    API_KEY,
        listingId: @yellow_id,
        prov:      @prov,
        'bus-name' => @name,
        fmt:    'json',
        lang:   'fr',
      }
      url = 'http://api.sandbox.yellowapi.com/GetBusinessDetails/?' + URI.encode_www_form(params)
      puts url

      data = JSON.load(open(url))
      @telephone = data['phones'].first['displayNum'] if data['phones']
      @website   = data['products']['webUrl'].first if data['products'] and data['products']['webUrl'] 
    end

  end

end