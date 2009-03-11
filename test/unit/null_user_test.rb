require File.dirname(__FILE__) + '/../unit_test_helper'

class NullUserTest < Test::Unit::TestCase

  def test_new_record_is_true
    assert_equal true, NullUser.new.new_record?
  end
  
  def test_strip_shows_is_empty
    assert_equal [], NullUser.new.strip_shows
  end
  
  def test_has_stripshow_is_false
    assert_equal false, NullUser.new.has_stripshow
  end
  
  def test_has_interest_is_false
    assert_equal false, NullUser.new.has_interest?(nil)
  end
  
  def test_has_kink_is_false
    assert_equal false, NullUser.new.has_kink?(nil)
  end
  
  def test_id_is_zero
    assert_equal 0, NullUser.new.id
  end
  
end
