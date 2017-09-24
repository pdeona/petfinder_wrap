# require "petfinder/wrap/version"
require_relative 'petfinder/pet'
require_relative 'petfinder/shelter'
require_relative 'petfinder/client'
require 'open-uri'

include Petfinder

module Petfinder
  VERSION = "1.0.0"

  def authenticate client_key
    @client_key = client_key
  end

  class Error < StandardError; end

  class << self
    attr_accessor :api_key, :api_secret
  end

end
