# RestaurantCrawler

[![Gem Version](https://badge.fury.io/rb/restaurant_crawler.svg)](https://rubygems.org/gems/restaurant_crawler)

J'ai eu besoin de récupérer les nom, siteweb et addresse mail de restaurants francais pour faire de la prospection:

> Moi: Quoi? 1500 € pour acheter une simple liste de restaurants? 

> Ruby: Bouge pas, je vais t'aider!

Quelques heures plus tard: plus de 800 résultats gratuits juste avec **Nokogiri** et **Anemone**.

Si cela peu servir à quelqu'un, voici les sources ;) .

## usage

### From instalation

Add this line to your application's Gemfile:

```ruby
gem 'restaurant_crawler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install restaurant_crawler

and then you'll be able to run from console

    $ restaurant_crawler.rb --h
    Usage: restaurant_crawler [options]
        -c, --crawl                      Start to crawl restopolitan.com
        -e, --email                      Start to fetch email from database (need to run crawl before)


### From source 

    $ git clone https://github.com/madeindjs/restaurant_crawler.git
    $ cd restaurant_crawler
    $ bundle install
    $ rake -T 
    rake crawl            # start crawler
    rake find_emails      # find emails of restaurants crawled

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Alex Rousseau/restaurant_crawler. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

