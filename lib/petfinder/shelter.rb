module Petfinder
  class Shelter

    attr_reader :country, :name, :phone, :state, :address, :email, :city, :zip, :id

    def initialize attributes
      @country = attributes["country"]["$t"]
      @name = attributes["name"]["$t"]
      @phone = attributes["phone"]["$t"]
      @state = attributes["state"]["$t"]
      @address = attributes["address1"]
      @email = attributes["email"]["$t"]
      @city = attributes["city"]["$t"]
      @zip = attributes["zip"]["#$t"]
      @id = attributes["id"]["$t"]
    end

    def get_pets
      get_shelter_pets = API_BASE_URI + "shelter.getPets?key=#{api_key}&id=#{@id}&output=basic&format=json"
      response = open(get_shelter_pets).read
      res = []
      if resp = JSON.parse(response)
        resp["petfinder"]["pets"].each do |pet|
          res << Petfinder::Pet.new(pet[1][0])
        end
      end
      res
    end

  end
end
