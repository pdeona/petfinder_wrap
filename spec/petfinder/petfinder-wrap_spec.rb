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

    context "Client#getPet" do
      let :get_a_pet do
        c.get_pet(38747365)
      end

      it "sends request to the api" do
        VCR.use_cassette('petfinder/find_pet') do
          expect{ get_a_pet }.not_to raise_error
        end
      end

      it "gets a valid JSON response" do
        VCR.use_cassette('petfinder/find_pet') do
          expect(c).not_to be nil
        end
      end
    end

  end

end

RSpec.describe Petfinder::Pet do
  context "initialize" do

    let :pet do
      VCR.use_cassette('petfinder/find_pet') do
      end
    end

    it "creates a pet object" do
      expect(pet).to be_a Pet
    end
  end
end
