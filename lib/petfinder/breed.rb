module Petfinder
  class Breed
    attr_reader :name
    attr_accessor :animal
    def initialize breed
      @name = breed["$t"]
    end
  end
end
