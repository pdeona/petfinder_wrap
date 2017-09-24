module Petfinder


  class Pet
    attr_reader :contact, :name, :breed, :age, :size, :id, :shelter_id, :media
    def initialize pet_hash
      @contact = pet_hash["contact"]
      @name = pet_hash["name"]["$t"]
      @breed = pet_hash["breed"]
      @age = pet_hash["age"]
      @size = pet_hash["size"]
      @id = pet_hash["id"]
      @shelter_id = pet_hash["shelterPetId"]
      @media = pet_hash["media"]
    end
  end
end
