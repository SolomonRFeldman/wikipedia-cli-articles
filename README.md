# Wikipedia-Cli-Articles

This gem scrapes a wikipedia article into a page class, which then has each section listed in the table of contents stored in its sections attribute with each section containing its text. It also scrapes the infobox which stores as a section class in the infobox attribute of the page. This gem is navagable through the CLI which allows the user to enter a wikipedia article and get its information displayed in the console.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wikipedia-cli-articles'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wikipedia-cli-articles

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SolomonRFeldman/wikipedia-cli-articles. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
