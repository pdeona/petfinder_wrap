require "spec_helper"


RSpec.describe Petfinder::Client do
  context "Client initialize" do
    let :client_key do
      Petfinder.api_key = "31644babd91732885c1b7962a39b02bd"
    end

    let :client_secret do
      Petfinder.api_secret = "3d72e8837e2db4cb644a60b063905724"
    end

    it "creates a Client object on initialize" do
      client_key
      c = Client.new
      expect(c).not_to be nil
    end


  end

end
