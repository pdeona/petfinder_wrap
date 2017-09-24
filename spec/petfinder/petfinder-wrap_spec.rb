require "spec_helper"
require 'vcr'

VCR.configure do |c|
  #the directory where your cassettes will be saved
  c.cassette_library_dir = 'spec/vcr'
  # your HTTP request service.
  c.hook_into :webmock
end


RSpec.describe Petfinder::Client do
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
          config.api_secret = "3d72e8837e2db4cb644a60b063905724"
        end
        }.not_to raise_error
    end

    it "successfully initializes new clients with config settings" do
      Petfinder.configure do |config|
        config.api_key = "31644babd91732885c1b7962a39b02bd"
        config.api_secret = "3d72e8837e2db4cb644a60b063905724"
      end
      expect{ Petfinder::Client.new }.not_to raise_error
    end
  end

  context "initialize" do

    let :c {
      Petfinder.api_key = "31644babd91732885c1b7962a39b02bd"
      Petfinder.api_secret = "3d72e8837e2db4cb644a60b063905724"
      c = Client.new
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
        expect(pets.first).to be_a Pet
        expect(pets.last).to be_a Pet
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
  end

  describe Petfinder::Pet do
    context "initialize" do

      let :pet do
        VCR.use_cassette('petfinder/find_pet') do
          pet = Client.new.find_pet 38747365
        end
      end

      it "creates a pet object" do
        expect(pet).to be_a Pet
      end

      it "has attribute reader methods" do
        expect{ pet.name }.not_to raise_error
      end
    end
  end

  describe Petfinder::Shelter do
    context "initialize" do
      let :shelter do
        VCR.use_cassette("petfinder/get_shelter") do
          shelter = Client.new.get_shelter "FL54"
        end
      end

      it "creates a shelter object" do
        expect(shelter).to be_a Shelter
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
            shelter = Client.new.get_shelter "FL54"
            shelter_pets = shelter.get_pets
          end
        end

        it "returns an Array of Pet objects" do
          expect(shelter_pets.first).to be_a Pet
        end
      end
    end
  end
end
