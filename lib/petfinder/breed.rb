module Petfinder
  class Breed
    attr_reader :animal, :name
    def initialize breed, animal
      @animal = animal
      @name = breed
    end
  end
end
