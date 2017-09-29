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
        begin
          pet = Petfinder::Pet.new(resp["petfinder"]["pet"])
          if pet.attributes.nil?
            raise Petfinder::Error.new "Invalid response received from API. Check your query"
          else
            pet
          end
        rescue Petfinder::Error => e
          puts e.message
        end
      else
        raise Petfinder::Error.new "No valid JSON response from API"
      end
    end

    def find_pets animal, zip_code
      find_pets_request = API_BASE_URI + "pet.find?key=#{@api_key}&animal=#{animal}&location=#{zip_code}&output=basic&format=json"
      # p find_pets_request
      response = open(find_pets_request).read
      res = []
      if resp = JSON.parse(response)
        begin
          resp["petfinder"]["pets"].each do |pet|
            res << Petfinder::Pet.new(pet[1][0])
          end
        rescue NoMethodError => e
          puts e.message
          puts "Invalid response received from API. Check your query"
        end
      end
      res
    end

    def get_shelter id
      get_shelter_request = API_BASE_URI + "shelter.get?key=#{@api_key}&id=#{id}&format=json"
      response = open(get_shelter_request).read
      if resp = JSON.parse(response)
        shelter = Petfinder::Shelter.new(resp["petfinder"]["shelter"])
        begin
          if shelter.attributes.nil?
            raise Petfinder::Error.new "No pets received from API. Check your query"
          else
            shelter
          end
        rescue Petfinder::Error => e
          puts e.message
        end
      else
        raise Petfinder::Error.new "No valid JSON response from API"
      end
    end

    def get_shelter_pets shelter
      get_shelter_pets = API_BASE_URI + "shelter.getPets?key=#{@api_key}&id=#{shelter.id}&output=basic&format=json"
      response = open(get_shelter_pets).read
      res = []
      if resp = JSON.parse(response)
        begin
          resp["petfinder"]["pets"]["pet"].each do |pet|
            res << Pet.new(pet)
          end
        rescue NoMethodError => e
          puts e.message
          puts "Invalid response received from API. Check your query"
        end
        res
      end
    end

    def find_shelters location
      find_shelters_request = API_BASE_URI + "shelter.find?key=#{@api_key}&location=#{location}&format=json"
      response = open(find_shelters_request).read
      res = []
      if resp = JSON.parse(response)
        begin
          resp["petfinder"]["shelters"]["shelter"].each do |shelter|
            res << Shelter.new(shelter)
          end
        rescue NoMethodError => e
          puts e.message
          puts "Invalid response received from API. Check your query"
        end
      end
      res
    end

    def breeds animal
      list_breeds_request = API_BASE_URI + "breed.list?key=#{@api_key}&animal=#{animal}&format=json"
      response = open(list_breeds_request).read
      res = []
      if resp = JSON.parse(response)
        begin
          resp["petfinder"]["breeds"]["breed"].each do |breed|
            res << Petfinder::Breed.new(breed["$t"], resp["petfinder"]["breeds"]["@animal"])
          end
        rescue NoMethodError => e
          puts e.message
          puts "Invalid response received from API. Check your query."
        end
      else
        raise Petfinder::Error "No valid JSON response from API"
      end
      res
    end

    def list_shelters_by_breed breed
      list_shelters_by_breed_request = API_BASE_URI + \
                    "shelter.listByBreed?key=#{@api_key}&animal=#{breed.animal}&breed=#{breed.name}&format=json"
      response = open(list_shelters_by_breed_request).read
      res = []
      if resp = JSON.parse(response)
        begin
          resp["petfinder"]["shelters"]["shelter"].each do |shelter|
            res << Petfinder::Shelter.new(shelter)
          end
        rescue NoMethodError => e
          puts e.message
          puts "Invalid response received from API. Check your query."
        end
      else
        raise Petfinder::Error "No valid JSON response received from API"
      end
      res
    end
  end
end
