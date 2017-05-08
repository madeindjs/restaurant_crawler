require 'json'
require 'nokogiri'
require 'open-uri'


module RestaurantCrawler

  class RestaurantPagesjaunes < Restaurant
    attr_reader :yellow_id

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
    def initialize yellow_data
      @yellow_id = yellow_data['id']
      @name      = yellow_data['name']
      @website   = '?' if yellow_data['content']['Url']['avail']
      # build address to something like `1450, av Victoria, J4V 1M2, Greenfield Park, ` 
      address    = yellow_data['address']
      @address   = [ address['street'], address['pcode'], address['city'] ].join(', ')
    end


    def self.restaurants
      # build URL
      params = {
        what:   'restaurants',
        where:  'Rhone',
        UID:    '127.0.0.1',
        apikey: '29be7dv3qj9gvdyawn5ns8jt',
        pgLen:  140,
        fmt:    'json',
        lang:   'fr',
      }
      url = 'http://api.sandbox.yellowapi.com/FindBusiness/?' + URI.encode_www_form(params)

      # get data from API
      data = JSON.load(open(url))
      pages_count = data['summary']['pageCount'].to_i

      # get restaurants from 1st query
      data['listings'].each do |restaurant_data|
        yield RestaurantPagesjaunes.new restaurant_data rescue RuntimeError
      end

      # now query others pages
      (2..pages_count).each do |page_number|
        params['pg'] = page_number
        url = 'http://api.sandbox.yellowapi.com/FindBusiness/?' + URI.encode_www_form(params)
        JSON.load(open(url))['listings'].each do |restaurant_data|
          yield RestaurantPagesjaunes.new restaurant_data rescue RuntimeError
        end
        sleep 2 # to not exceed maximum request per seconds allowed  
      end

    end

  end

end