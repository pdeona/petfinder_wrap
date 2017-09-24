module Petfinder
  API_BASE_URI = "http://api.petfinder.com/"

  class Client

    attr_reader :api_key, :api_secret, :response

    def initialize api_key = Petfinder.api_key, api_secret = Petfinder.api_secret
      @api_key = api_key
      @api_secret = api_secret
      raise Petfinder::Error.new "API key is required" unless @api_key
    end

    def get_pet id
      request_uri = API_BASE_URI << "pet.get?"
      request_uri << "key=#{@api_key}&id=#{id}&format=json"
      @response = open(request_uri).read
      @response
    end

  end
end
