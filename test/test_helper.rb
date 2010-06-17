require "messenger"
require 'test/unit'
require 'shoulda'
require 'mocha'
require 'webmock/test_unit'

class Test::Unit::TestCase
  include WebMock
end

Dir["#{File.dirname(__FILE__)}/shoulda_macros/*.rb"].each {|file| require file }
