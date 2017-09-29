module Petfinder
  class Shelter
    extend JsonMapper

    json_attributes "country", "name", "phone", "state", "address", "email", "city", "zip", "id"

    attr_reader :attributes

    def initialize attributes
      @attributes = attributes
    end

    def get_pets
      res = Client.new.get_shelter_pets self
    end
  end
end
