require File.dirname(__FILE__) + '/../unit_test_helper'

class UserTest < Test::Unit::TestCase

  def test_equality
    assert_equal false, NullGender.new == nil
    assert_equal true, NullGender.new == NullGender.new
  end

end
