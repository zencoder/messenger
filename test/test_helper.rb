require "#{File.dirname(__FILE__)}/../lib/messenger"
require 'test/unit'
require 'shoulda'
require 'mocha'

Dir["#{File.dirname(__FILE__)}/shoulda_macros/*.rb"].each {|file| require file }
