require 'json'
require 'nokogiri'
require 'open-uri'


module RestaurantCrawler

  class RestaurantPagesjaunes < Restaurant

    URL = "https://www.pagesjaunes.fr/annuaire/chercherlespros?quoiqui=restaurants&ou=RHONE+%2869%29&idOu=D069&proximite=0&quoiQuiInterprete=restaurants"

    def initialize 
      raise RuntimeError.new "Not implemented error"
    end


    def self.restaurants

    	params = {
    		what: 'restaurants',
    		where: 'Rhone',
    		UID: '127.0.0.1',
    		apikey: '29be7dv3qj9gvdyawn5ns8jt',
    		pgLen: 140,
    		fmt: 'json',
    		lang: 'fr',
			}

			url = 'http://api.sandbox.yellowapi.com/FindBusiness/?' + URI.encode_www_form(params)

			puts JSON.load(open(url))

    end

  end

end