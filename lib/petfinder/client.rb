require 'json'

module Petfinder
  API_BASE_URI = "http://api.petfinder.com/"

  class Client

    attr_reader :api_key, :api_secret, :response, :request_uri

    def initialize api_key = Petfinder.api_key, api_secret = Petfinder.api_secret
      @api_key = api_key
      @api_secret = api_secret
      raise Petfinder::Error.new "API key is required" unless @api_key
    end

    def find_pet id
      find_pet_request = API_BASE_URI + "pet.get?key=#{@api_key}&id=#{id}&format=json"
      response = open(find_pet_request).read
      if resp = JSON.parse(response)
        Petfinder::Pet.new(resp["petfinder"]["pet"])
      else
        raise Petfinder::Error "No valid JSON response from API"
      end
    end

    def find_pets animal, zip_code
      find_pets_request = API_BASE_URI + "pet.find?key=#{@api_key}&animal=#{animal}&location=#{zip_code}&output=basic&format=json"
      # p find_pets_request
      response = open(find_pets_request).read
      res = []
      if resp = JSON.parse(response)
        resp["petfinder"]["pets"].each do |pet|
          res << Petfinder::Pet.new(pet[1][0])
        end
      end
      res
    end

    def get_shelter id
      get_shelter_request = API_BASE_URI + "shelter.get?key=#{@api_key}&id=#{id}&format=json"
      response = open(get_shelter_request).read
      response
    end

    def find_shelters location
      find_shelters_request = API_BASE_URI + "shelter.find?key=#{@api_key}&location=#{location}"
      response = open(find_shelters_request).read
      response
    end
  end
end
