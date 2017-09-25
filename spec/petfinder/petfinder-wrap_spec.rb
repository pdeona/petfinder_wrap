require "spec_helper"
require 'vcr'

VCR.configure do |c|
  #the directory where your cassettes will be saved
  c.cassette_library_dir = 'spec/vcr'
  # your HTTP request service.
  c.hook_into :webmock
end


RSpec.describe Petfinder::Client do

  context "initialize" do
    it "won't initialize without an API key" do
      expect { Petfinder::Client.new }.to raise_error(Petfinder::Error)
    end
  end

  context "config" do

    it "allows config to be run with a block" do
      expect{
        Petfinder.configure do |config|
          config = "test"
        end
        }.not_to raise_error
    end

    it "allows api keys to be entered as a block" do
      expect{
        Petfinder.configure do |config|
          config.api_key = "31644babd91732885c1b7962a39b02bd"
        end
        }.not_to raise_error
    end

    it "successfully initializes new clients with config settings" do
      Petfinder.configure do |config|
        config.api_key = "31644babd91732885c1b7962a39b02bd"
      end
      expect{ Petfinder::Client.new }.not_to raise_error
    end
  end

  context "initialize" do

    let :c {
      c = Petfinder::Client.new
    }

    it "creates a Client object on initialize" do
      expect(c).not_to be nil
    end

    it "stores api_key in an instance variable" do
      expect(c.api_key).to eq Petfinder.api_key
    end

    it "stores api_secret in an instance variable" do
      expect(c.api_secret).to eq Petfinder.api_secret
    end

    context "Client#findPet" do
      let :get_a_pet do
        c.find_pet(38747365)
      end

      it "sends request to the api" do
        VCR.use_cassette('petfinder/find_pet') do
          expect{ get_a_pet }.not_to raise_error
        end
      end

      it "makes a Pet object with the response" do
        VCR.use_cassette('petfinder/find_pet') do
          pet = get_a_pet
          expect(pet).to be_a Petfinder::Pet
        end
      end
    end

    context "Client#getPets" do
      let :pets do
        VCR.use_cassette('petfinder/find_pets') do
          pets = c.find_pets "dog", "33165"
        end
      end

      it "sends an API request using .findPets" do
        expect(pets).not_to be nil
      end

      it "retrieves an array of Pet objects" do
        expect(pets.first).to be_a Petfinder::Pet
        expect(pets.last).to be_a Petfinder::Pet
      end

      it "allows user to view individual Pet objects" do
        expect(pets.first.name).not_to be nil
      end
    end

    context "Client#getShelter" do
      let :shelter do
        VCR.use_cassette('petfinder/get_shelter') do
          shelter = c.get_shelter "FL54"
        end
      end

      it "sends an API request using .getShelter" do
        expect(shelter).not_to be nil
      end

      it "returns a single Shelter object" do
        expect(shelter).to be_a Petfinder::Shelter
      end
    end

    context "Client#find_shelters" do
      let :shelters do
        VCR.use_cassette('petfinder/find_shelters') do
          shelters = c.find_shelters "33165"
        end
      end

      it "allows a user to search for shelters by zip code" do
        expect{ shelters }.not_to raise_error
      end

      it "successfully retrieves a response from the API" do
        expect(shelters).not_to be nil
      end

      it "successfully parses the response into an array of Shelter objects" do
        expect(shelters.first).to be_a Petfinder::Shelter
        expect(shelters.last).to be_a Petfinder::Shelter
      end
    end
  end


  describe Petfinder::Pet do
    context "#initialize" do

      let :pet do
        VCR.use_cassette('petfinder/find_pet') do
          pet = Petfinder::Client.new.find_pet 38747365
        end
      end

      it "creates a pet object" do
        expect(pet).to be_a Petfinder::Pet
      end

      it "the object has attribute reader methods" do
        expect{ pet.name }.not_to raise_error
      end

      it "the object has a photos method" do
        expect{ pet.photos }.not_to raise_error
      end
    end

    context "#contact" do
      let :pet do
        VCR.use_cassette('petfinder/find_pet') do
          pet = Petfinder::Client.new.find_pet 38747365
        end
      end

      it "returns a hash of contact info" do
        expect(pet.contact_info).to be_a Hash
      end
    end

    context "#photos" do
      let :photos do
        VCR.use_cassette('petfinder/find_pet') do
          pet = Petfinder::Client.new.find_pet 38747365
          photos = pet.photos
        end
      end

      it "returns an array" do
        expect(photos).to be_a Array
      end

      it "the array contains Photo objects" do
        expect(photos.first).to be_a Petfinder::Pet::Photo
        expect(photos.last).to be_a Petfinder::Pet::Photo
      end

      describe Petfinder::Pet::Photo do
        let :photo do
          photo = photos.first
        end

        let :photo_size_run do
          photo = photos.first
          photo.large = "test"
          photo.small = "test"
          photo.medium = "test"
          photo.thumbnail = "test"
          photo.tiny = "test"
          photo
        end

        it "has an id reader method" do
          expect{ photo.id }.not_to raise_error
        end

        it "has getter methods for .large, .small, .medium, .thumbnail, .tiny" do
          expect{ photo.large }.not_to raise_error
          expect{ photo.small }.not_to raise_error
          expect{ photo.medium }.not_to raise_error
          expect{ photo.tiny }.not_to raise_error
          expect{ photo.thumbnail }.not_to raise_error
        end

        it "has setter methods for .large, .small, .medium, .thumbnail, .tiny" do
          expect(photo_size_run.tiny).to eq("test")
          expect(photo_size_run.small).to eq("test")
          expect(photo_size_run.medium).to eq("test")
          expect(photo_size_run.thumbnail).to eq("test")
          expect(photo_size_run.large).to eq("test")
        end

        it "method returns image url for small photo" do
          expect(photo.small).to eq(photos.first.small)
        end
      end
    end
  end

  describe Petfinder::Shelter do
    context "initialize" do
      let :shelter do
        VCR.use_cassette("petfinder/get_shelter") do
          shelter = Petfinder::Client.new.get_shelter "FL54"
        end
      end

      it "creates a shelter object" do
        expect(shelter).to be_a Petfinder::Shelter
      end

      it "has attribute reader methods" do
        expect{ shelter.name }.not_to raise_error
      end

      it "has a get_pets method" do
        VCR.use_cassette("petfinder/shelter_get_pets") do
          expect{ shelter.get_pets }.not_to raise_error
        end
      end

      context "#getPets" do

        let :shelter_pets do
          VCR.use_cassette('petfinder/shelter_get_pets') do
            shelter = Petfinder::Client.new.get_shelter "FL54"
            shelter_pets = shelter.get_pets
          end
        end

        it "returns an Array of Pet objects" do
          expect(shelter_pets.first).to be_a Petfinder::Pet
        end
      end
    end
  end
end
