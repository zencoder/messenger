require "test_helper"

class Messenger::ResultTest < Test::Unit::TestCase

  context "A result" do

    should "return success as a boolean" do
      result = Messenger::Result.new(true, "Response")
      assert result.success?
      result = Messenger::Result.new(false, "Response")
      assert_equal false, result.success?
    end

    should "give access to the raw response" do
      result = Messenger::Result.new(true, "Response")
      assert_equal "Response", result.response
    end

  end

end
