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

    let :client do
      client = Petfinder::Client.new
    end

    it "creates a Client object on initialize" do
      expect(client).not_to be nil
    end

    it "stores api_key in an instance variable" do
      expect(client.api_key).to eq Petfinder.api_key
    end

    it "stores api_secret in an instance variable" do
      expect(client.api_secret).to eq Petfinder.api_secret
    end

    context "#findPet" do
      let :get_a_pet do
        client.find_pet(38747365)
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

      it "rescues invalid responses" do
        VCR.use_cassette('petfinder/find_invalid') do
          expect{ client.find_pet 123 }.not_to raise_error
        end
      end
    end

    context "#getPets" do
      let :pets do
        VCR.use_cassette('petfinder/find_pets') do
          pets = client.find_pets "dog", "33165"
        end
      end

      it "sends an API request using .findPets" do
        expect(pets).not_to be nil
      end

      it "retrieves an array of Pet objects" do
        pets.each do |pet|
          expect(pet).to be_a Petfinder::Pet
        end
      end

      it "allows user to view individual Pet objects" do
        expect(pets.first.name).not_to be nil
      end

      it "rescues invalid responses" do
        VCR.use_cassette('petfinder/find_pets_invalid') do
          expect{ client.find_pets "doggo", "bamboozled" }.not_to raise_error
        end
      end
    end

    context "#getShelter" do
      let :shelter do
        VCR.use_cassette('petfinder/get_shelter') do
          shelter = client.get_shelter "FL54"
        end
      end

      it "sends an API request using .getShelter" do
        expect(shelter).not_to be nil
      end

      it "returns a single Shelter object" do
        expect(shelter).to be_a Petfinder::Shelter
      end

      it "rescues invalid responses" do
        VCR.use_cassette('petfinder/find_invalid_shelter') do
          expect{ client.get_shelter 123 }.not_to raise_error
        end
      end
    end

    context "#find_shelters" do
      let :shelters do
        VCR.use_cassette('petfinder/find_shelters') do
          shelters = client.find_shelters "33165"
        end
      end

      it "allows a user to search for shelters by zip code" do
        expect{ shelters }.not_to raise_error
      end

      it "successfully retrieves a response from the API" do
        expect(shelters).not_to be nil
      end

      it "successfully parses the response into an array of Shelter objects" do
        shelters.each do |shelter|
          expect(shelter).to be_a Petfinder::Shelter
        end
      end

      it "rescues invalid responses" do
        VCR.use_cassette('petfinder/find_invalid_shelters') do
          expect{ client.find_shelters 123 }.not_to raise_error
        end
      end
    end

    context "#breeds" do
      let :breeds do
        VCR.use_cassette('petfinder/list_breeds') do
          breeds = client.breeds "dog"
        end
      end

      it "sends an api request" do
        expect{ breeds }.not_to raise_error
      end

      it "receives a JSON response" do
        expect{ breeds.to_json }.not_to raise_error
      end

      it "gets a list of breeds available for an animal class" do
        breeds.each do |breed|
          expect(breed).to be_a Petfinder::Breed
        end
      end

      it "rescues invalid responses" do
        VCR.use_cassette('petfinder/find_invalid_breeds') do
          expect{ client.breeds "alien monkey" }.not_to raise_error
        end
      end

      context "#list_shelters_by_breed" do
        let :breed do
          breed = breeds.first
        end

        let :breed_shelters do
          VCR.use_cassette('petfinder/list_shelters_by_breed') do
            breed_shelters = client.list_shelters_by_breed(breed)
          end
        end

        it "parses an api response" do
          expect{ breed_shelters }.not_to raise_error
        end

        it "returns a list of shelter objects" do
          breed_shelters.each do |shelter|
            expect(shelter).to be_a Petfinder::Shelter
          end
        end

        it "rescues invalid responses" do
          VCR.use_cassette('petfinder/find_invalid_shelters_by_breed') do
            fake_breed = Petfinder::Breed.new({"$t" => "chupacabra"})
            fake_breed.animal = "goat-eating_beast"
            expect{ client.list_shelters_by_breed(fake_breed) }.not_to raise_error
          end
        end
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

      it "returns an array of names" do
        expect(pet.contact_info).to be_a Array
      end

      it "each name in the array corresponds to a method" do
        pet.contact_info.each do |name|
          expect(pet.methods).to include name.to_sym
        end
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
        photos.each do |photo|
          expect(photo).to be_a Petfinder::Pet::Photo
        end
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
          [:large, :small, :medium, :thumbnail, :tiny].each do |size|
            expect{ photo.send(size) }.not_to raise_error
          end
        end

        it "has setter methods for .large, .small, .medium, .thumbnail, .tiny" do
          [:large, :small, :medium, :thumbnail, :tiny].each do |size|
            expect(photo_size_run.send(size)).to eq("test")
          end
          expect(photo_size_run.tiny).to eq("test")
        end

        it "method returns image url for small photo" do
          photo_small = "http://photos.petfinder.com/photos/pets/38747365/1/?bust=1499922306&width=95&-fpm.jpg"
          expect(photo.small).to eq(photo_small)
        end

        it "method returns image url for medium photo" do
          photo_medium = "http://photos.petfinder.com/photos/pets/38747365/1/?bust=1499922306&width=300&-pn.jpg"
          expect(photo.medium).to eq(photo_medium)
        end

        it "method returns image url for large photo" do
          photo_large = "http://photos.petfinder.com/photos/pets/38747365/1/?bust=1499922306&width=500&-x.jpg"
          expect(photo.large).to eq(photo_large)
        end

        it "method returns image url for tiny photo" do
          photo_tiny = "http://photos.petfinder.com/photos/pets/38747365/1/?bust=1499922306&width=60&-pnt.jpg"
          expect(photo.tiny).to eq(photo_tiny)
        end
      end
    end

    context "#breed" do

      let :pet do
        VCR.use_cassette('petfinder/find_pet') do
          pet = Petfinder::Client.new.find_pet 38747365
        end
      end

      let :pet_breed do
        pet_breed = pet.breed
      end

      it "returns a breed object matching the corresponding pet" do
        expect(pet_breed).to be_a Petfinder::Breed
        expect{ pet_breed.name }.not_to raise_error
        expect{ pet_breed.animal }.not_to raise_error
      end

      it "returns a breed object that can be passed to client#list_shelters_by_breed" do
        VCR.use_cassette('petfinder/search_shelters_by_pet_breed') do
          client = Petfinder::Client.new
          response = client.list_shelters_by_breed(pet_breed)
          response.each do |shelter|
            expect(shelter).to be_a Petfinder::Shelter
          end
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

  describe Petfinder::Breed do
    context 'initialize' do
      let :shelter do
        VCR.use_cassette("petfinder/get_shelter") do
          shelter = Petfinder::Client.new.get_shelter "FL54"
        end
      end

      let :breed do
        VCR.use_cassette('petfinder/list_breeds') do
          client = Petfinder::Client.new
          breed = (client.breeds "dog").first
        end
      end

      it "has a name" do
        expect{ breed.name }.not_to raise_error
      end

      it "has an animal type" do
        expect{ breed.animal }.not_to raise_error
      end
    end
  end
end
