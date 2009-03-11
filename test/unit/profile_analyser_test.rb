require File.dirname(__FILE__) + '/../test_helper'

class ProfileAnalyserTest < Test::Unit::TestCase
  fixtures :profiles, :genders, :tags
  
  def setup
    @profile = Profile.new
    @analyser = ProfileAnalyser.new(@profile)
  end
  
  def test_initializer_raises_exception_if_profile_is_nil
    assert_raises ArgumentError do
      ProfileAnalyser.new(nil)
    end
  end
  
  def test_that_percent_complete_is_zero_for_a_new_profile
    assert_equal 0, @analyser.percent_complete
  end
  
  def test_percent_complete_if_has_avatar_image
    @profile.stubs(:has_avatar?).returns(true)
    assert_equal 20, @analyser.percent_complete
  end
  
  def test_percent_complete_if_has_gender
    @profile.stubs(:has_gender?).returns(true)
    assert_equal 10, @analyser.percent_complete
  end

  def test_percent_complete_if_has_sexuality
    @profile.stubs(:has_sexuality?).returns(true)
    assert_equal 10, @analyser.percent_complete
  end
  
  def test_percentage_complete_if_has_interests
    @profile.stubs(:interest_tags).returns([tags(:fluffy)])
    assert_equal 15, @analyser.percent_complete
  end
  
  def test_percentage_complete_if_has_kinks
    @profile.stubs(:kink_tags).returns([tags(:fluffy)])
    assert_equal 15, @analyser.percent_complete
  end
  
  def test_percentage_complete_if_has_welcome_text
    @profile.stubs(:welcome_text).returns('hi there')
    assert_equal 15, @analyser.percent_complete
  end  

  def test_percentage_complete_if_has_gallery_photos
    @profile.stubs(:display_photos).returns([GalleryPhoto.new])
    assert_equal 15, @analyser.percent_complete
  end  

end
