module Petfinder

  class Pet
    extend JsonMapper

    json_attributes "name", "breed", "age", "size", "id", "shelter_id",
                    "description", "shelter_id"

    attr_reader :attributes, :contact_info
    def initialize pet_hash
      @attributes = pet_hash
      @contact_info = contact
    end

    def photos
      parse_photos if @photos.nil?
      @photos
    end

    private

    def contact
      class << self
        json_attributes "phone", "state", "email", "city",
                        "zip", "fax", "address1"
      end
    end

    def parse_photos
      @photos = []
      @attributes["media"]["photos"]["photo"].each do |photo|
        add_photo photo, photo["$t"]
      end
    end

    def add_photo photo, url
      size = photo["@size"]
      photo = set_photo photo
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
      @photos << photo unless @photos.find_index photo
    end

    def set_photo photo
      @photos.each do |existing_photo|
        if photo["@id"] == existing_photo.id
          return existing_photo
        end
      end
      Photo.new photo
    end

    class Photo

      attr_accessor :large, :medium, :small, :thumbnail, :tiny
      attr_reader :id, :attributes

      def initialize attributes
        @attributes = attributes
        @id = attributes["@id"]
      end

    end

  end
end
