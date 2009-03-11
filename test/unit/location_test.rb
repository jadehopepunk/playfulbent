require File.dirname(__FILE__) + '/../test_helper'

class LocationTest < Test::Unit::TestCase
  fixtures :locations

  #-----------------------------------------------------
  # NAME
  #-----------------------------------------------------
  
  def test_that_name_returns_city_then_country
    assert_equal 'Melbourne, Australia', Location.new(:city => 'Melbourne', :country => 'Australia').name
  end
  
  def test_that_name_returns_city_if_location_has_no_country
    assert_equal 'Melbourne', Location.new(:city => 'Melbourne', :country => '').name
  end
  
  def test_that_name_returns_country_if_location_has_no_city
    assert_equal 'Australia', Location.new(:city => '', :country => 'Australia').name
  end

  def test_that_name_returns_empty_string_if_location_has_no_info
    assert_equal '', Location.new(:city => '', :country => '').name
  end

  #-----------------------------------------------------
  # CONTAINS NO DATA?
  #-----------------------------------------------------
  
  def test_contains_no_data
    assert_equal false, Location.new(:city => 'Auckland', :country => 'New Zealand').contains_no_data?
    assert_equal false, Location.new(:city => '', :country => 'New Zealand').contains_no_data?
    assert_equal false, Location.new(:city => 'Auckland', :country => '').contains_no_data?
    assert_equal true, Location.new(:city => '', :country => '').contains_no_data?
  end
  
end
