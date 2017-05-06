require 'json'
require 'nokogiri'
require 'open-uri'


module RestaurantCrawler

  class RestaurantPagesjaunes < Restaurant


    def initialize 
      raise RuntimeError.new "Not implemented error"
    end


    def self.restaurants

    	params = {
    		what: 'restaurants',
    		where: 'Rhone',
    		UID: '127.0.0.1',
    		apikey: '29be7dv3qj9gvdyawn5ns8jt',
    		pgLen: 10,
    		fmt: 'json',
    		lang: 'fr',
			}

			url = 'http://api.sandbox.yellowapi.com/FindBusiness/?' + URI.encode_www_form(params)

			data = JSON.load(open(url))


			data['listings'].each do |restaurant_data|
				puts restaurant_data.inspect
			end

			exit!

			puts pages_count = data['summary']['pageCount'].to_i

			(2..pages_count).each do |page_number|
			end

    end



  end

end