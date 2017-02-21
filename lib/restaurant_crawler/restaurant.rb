require 'nokogiri'

module RestaurantCrawler


  class Restaurant

    attr_reader :doc
    attr_accessor :name, :website, :address

    def initialize nokogiri_doc
      @doc = nokogiri_doc
      # found name
      if h1 = @doc.at_css("h1")
        @name = h1.text.chomp
      else
        raise RuntimeError.new "T"
      end
      # found website
      @doc.css("a").each do |link|
        if link.text.include? "Site du restaurant"
          @website = link['href'].chomp
          break
        end
      end

      raise RuntimeError.new "Restaurant's website not found" unless @website

      # found address
      if p = @doc.at_css("div.addressInfo")
        @address = p.text.chomp
      else
        raise RuntimeError.new "Restaurant's address not found"
      end
    end


    def to_s
      "#{@name}: #{@website}"
    end

    
  end


end