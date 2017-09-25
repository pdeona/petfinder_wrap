module Petfinder
  class Shelter
    extend JsonMapper
    json_attributes "country", "name", "phone", "state", "address", "email", "city", "zip", "id"

    def initialize attributes
      @attributes = attributes
    end

    def get_pets
      get_shelter_pets = API_BASE_URI + "shelter.getPets?key=#{Client.new.api_key}&id=#{id}&output=basic&format=json"
      response = open(get_shelter_pets).read
      res = []
      if resp = JSON.parse(response)
        resp["petfinder"]["pets"]["pet"].each do |pet|
          # res << Petfinder::Pet.new(pet[1][0])
          res << Pet.new(pet)
        end
      end
      res
    end

  end
end
