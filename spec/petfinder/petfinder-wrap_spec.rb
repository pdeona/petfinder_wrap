require "spec_helper"


RSpec.describe Petfinder::Client do
  context "initialize" do
    let :client_key do
      Petfinder.api_key = "31644babd91732885c1b7962a39b02bd"
    end

    let :client_secret do
      Petfinder.api_secret = "3d72e8837e2db4cb644a60b063905724"
    end

    let :c do
      client_key
      client_secret
      c = Client.new
    end

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

      it "sends request to the api" do
        expect{ c.get_pet(12345) }.not_to raise_error
      end

      it "gets a valid response" do
        c.get_pet(12345)
        expect(c.response).not_to be nil
      end

      it "creates a Pet object"
    end

  end

end
