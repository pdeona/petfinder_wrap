# require "petfinder/wrap/version"
require_relative 'petfinder/pet'
require_relative 'petfinder/shelter'
require_relative 'petfinder/client'
require 'open-uri'

include Petfinder

module Petfinder
  VERSION = "1.0.0"

  class Error < StandardError; end

  class << self
    attr_accessor :api_key, :api_secret
  end

  def self.configure
    yield self
    true
  end

end
