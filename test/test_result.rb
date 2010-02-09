require "#{File.dirname(__FILE__)}/test_helper"

module Messenger

  class ResultTest < Test::Unit::TestCase

    context "A result" do

      should "return success as a boolean" do
        result = Result.new(true, "Response")
        assert result.success?
        result = Result.new(false, "Response")
        assert_equal false, result.success?
      end

      should "give access to the raw response" do
        result = Result.new(true, "Response")
        assert_equal "Response", result.response
      end

    end

  end

end
