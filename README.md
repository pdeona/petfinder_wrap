# Petfinder::Wrap

A simple gem for the Petfinder API using JSON responses and a traversal method.

Added in 1.0.4:
* `<#Client>.list_shelters_by_breed` => returns a list of shelter objects matching the passed in `Breed` object.

* All API endpoints have now been built out. Please submit issues or bugs to the link at the bottom of the page.

Coming in the next release:

* Options hashes (you rubes love options hashes) for sending in the optional parameters each API method allows


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'petfinder-wrap'
```

And then execute:

    $ bundle

OR:
```
    $ bundle add petfinder-wrap
    $ bundle install
```
to automatically add it to your Gemfile and install it.

Or install it yourself as:

    $ gem install petfinder-wrap

## Usage

If you are using in a rails app, place the following
into config/initializers/petfinder.rb:

```ruby
      Petfinder.configure do |config|
        config.api_key = "YOUR API KEY HERE"
        config.api_secret = "YOUR API SECRET HERE" # not needed yet, do not use
      end
```

note: Currently, the API does not utilize a client secret for any requests. You are probably better off not setting this value in your code. In the future if they add PUT, POST, DELETE endpoints that require auth, the above config will work, if someone wants to build out those methods.

For non-rails applications, add the gem to your Gemfile (see above) then:
`your_app.rb:`
```ruby
      require 'petfinder-wrap'

      Petfinder.configure do |config|
        config.api_key = "YOUR API KEY HERE"
        config.api_secret = "YOUR API SECRET HERE" # not needed yet, do not use
      end
```

Afterward, you should be able to use
```ruby
client = Petfinder::Client.new
client.find_pets "dog", "33165" # => returns an array of Pets
client.find_pet "38747365" # => returns a single Pet
client.find_shelters "33131" # => returns an array of Shelters
client.get_shelter "FL54" # => returns a single Shelter object
```


Additionally, try methods like
```ruby
pet = client.find_pet "38747365"
pet.name # => returns the pet's name
pet.photos # => returns an array of Photo objects, with multiple size urls accessible by .small, .medium, .large, .thumbnail, .tiny
pet.contact_info # => returns a hash of callable method names for contact info
pet.phone # => returns the phone # associated with this pet
pet.address1 # => returns the address associated with this pet
pet.city # => returns the city
pet.zip # => returns the postal code
```
the same should function for shelters.

Please see below for bug reporting and pull requests.
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pdeona/petfinder-wrap.
