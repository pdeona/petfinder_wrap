module Petfinder

  class Pet
    extend JsonMapper

    json_attributes "name", "breed", "age", "size", "id", "shelter_id",
                    "description", "shelter_id"

    attr_reader :media, :contact
    def initialize pet_hash
      @attributes = pet_hash
    end

    def contact
    end
  end
end
