# Petfinder::Wrap

A simple gem for the Petfinder API using JSON responses and a traversal method.

TODO: build out <#Pet>.photos instance methods for max usability in rails apps.

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
note: Currently, the API does not utilize a client secret for any requests. You are probably better off not setting this value in your code. In the future if they add PUT, POST, DELETE endpoints that require auth, the above config will work, if someone wants to build out those methods.

Afterward, you should be able to use
```ruby
client = Petfinder::Client.new
client.find_pets("dog", "33165") # => returns an array of Pets
client.find_pet("38747365") # => returns a single Pet
client.find_shelters("33131") # => returns an array of Shelters
client.get_shelter("FL54") # => returns a single Shelter object
```

Additionally, try methods like
```ruby
pet = client.find_pet("38747365")
pet.name # => returns the pet's name
pet.contact # => returns a hash of contact info
```
the same should function for shelters.

Please see below for bug reporting and pull requests.
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pdeona/petfinder-wrap.
