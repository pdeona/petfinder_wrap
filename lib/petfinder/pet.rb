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

    def photos
      parse_photos if @photos.nil?
      @photos
    end

    private

    def parse_photos
      @photos = []
      @attributes["media"]["photos"]["photo"].each do |photo|
        add_photo photo, photo["@id"]
      end
    end

    def add_photo photo, id
      photo = set_photo photo, id
      url = photo.attributes["$t"]
      size = photo.attributes["@size"]
      case size
      when "x"
        photo.large = url
      when "pn"
        photo.medium = url
      when "fpm"
        photo.small = url
      when "pnt"
        photo.tiny = url
      end
      @photos << photo unless @photos.include? photo
    end

    def set_photo photo, id
      @photos.each do |existing_photo|
        if id == existing_photo.id
          return existing_photo
        end
      end
      Photo.new photo
    end

    class Photo
      extend JsonMapper

      attr_accessor :large, :medium, :small, :thumbnail, :tiny
      attr_reader :attributes, :id

      def initialize attributes
        @attributes = attributes
        @id = attributes["@id"]
      end
    end

  end
end
