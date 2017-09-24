module Petfinder
  API_BASE_URI = "http://api.petfinder.com/"

  class Pet
    def initialize attributes

    end

    def self.get_random_pet
      client_key = Petfinder.authenticate
      request_uri = API_BASE_URI << "pet.getRandom?"
      request_uri << "?key=#{client_key}&output=basic&format=json"
      response = open(request_uri)
      p response
    end
  end
end
