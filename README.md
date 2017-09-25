# Petfinder::Wrap

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/petfinder/wrap`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'petfinder-wrap'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install petfinder-wrap

## Usage

If you are using in a rails app, place the following into your config/application.rb:

```ruby
      Petfinder.configure do |config|
        config.api_key = "YOUR API KEY HERE"
        config.api_secret = "YOUR API SECRET HERE"
      end
```

Afterward, you should be able to use
```ruby
client = Petfinder::Client.new
client.find_pets("dog", "33165") # => an array of Pets
client.find_pet("38747365") # => returns a single Pet
client.find_shelters

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pdeona/petfinder-wrap.
