require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users, :email_addresses, :strip_show_views, :interactions, :interaction_counts, :crushes

  #----------------------------------------------------------
  # HAS INTEREST?
  #----------------------------------------------------------  
  
  def test_has_interest_is_false_with_no_profile
    @user = User.new
    assert_equal false, @user.has_interest?('fish')
  end
  
  def test_has_interest_is_false_with_profile_returning_false
    @user = User.new
    @profile = Profile.new
    @user.profile = @profile
    @profile.stubs(:has_interest?).with('fish').returns(false)
    assert_equal false, @user.has_interest?('fish')
  end
  
  def test_has_interest_is_true_with_profile_returning_true
    @user = User.new
    @profile = Profile.new
    @user.profile = @profile
    @profile.stubs(:has_interest?).with('fish').returns(true)
    assert_equal true, @user.has_interest?('fish')
  end

  #----------------------------------------------------------
  # HAS KINK?
  #----------------------------------------------------------
  
  def test_has_kink_is_false_with_no_profile
    @user = User.new
    assert_equal false, @user.has_kink?('fish')
  end
  
  def test_has_kink_is_false_with_profile_returning_false
    @user = User.new
    @profile = Profile.new
    @user.profile = @profile
    @profile.stubs(:has_kink?).with('fish').returns(false)
    assert_equal false, @user.has_kink?('fish')
  end
  
  def test_has_kink_is_true_with_profile_returning_true
    @user = User.new
    @profile = Profile.new
    @user.profile = @profile
    @profile.stubs(:has_kink?).with('fish').returns(true)
    assert_equal true, @user.has_kink?('fish')
  end
  
  #----------------------------------------------------------
  # GENDER NAME
  #----------------------------------------------------------
  
  def test_gender_name_defaults_to_unspecified
    @user = User.new
    assert_equal 'unspecified', @user.gender_name
  end
  
  def test_gender_name_returns_name_from_gender
    @user = User.new
    @user.gender = Gender.new(:name => 'banana')
    assert_equal 'banana', @user.gender_name
  end
  
  #----------------------------------------------------------
  # GENDER NAME =
  #----------------------------------------------------------
  
  def test_gender_name_assignment_sets_gender
    @user = User.new
    @user.gender_name = 'pineapple'
    assert_equal 'pineapple', @user.gender.name
  end
  
  #----------------------------------------------------------
  # CAN BE EDITED BY?
  #----------------------------------------------------------
  
  def test_can_be_edited_by?
    @user = User.new
    assert_equal false, @user.can_be_edited_by?(nil)
    assert_equal false, @user.can_be_edited_by?(User.new)
    assert_equal true, @user.can_be_edited_by?(@user)
  end
  
  #----------------------------------------------------------
  # GENDER
  #----------------------------------------------------------
  
  def test_gender_defaults_to_null_gender
    @user = User.new
    assert_equal Gender.unknown, @user.gender
  end
  
  def test_gender_is_assigned_gender
    @user = User.new
    gender = Gender.new(:name => 'fish')
    @user.gender = gender
    assert_equal 'fish', @user.gender.name
  end
  
  #----------------------------------------------------------
  # SEPERATE USERS BY PICTURE
  #----------------------------------------------------------
  
  def test_seperate_users_by_picture_returns_empty_arrays_for_no_users
    assert_equal [[], []], User.seperate_users_by_picture([])
  end

  def test_seperate_users_by_picture_splits_correctly
    with = User.new
    with.stubs(:has_avatar?).returns(true)
    without = User.new
    without.stubs(:has_avatar?).returns(false)
    
    assert_equal [[with, with, with], [without, without]], User.seperate_users_by_picture([with, without, with, with, without])
  end
  
  def test_seperate_users_by_picture_applies_maximum_with
    with = User.new
    with.stubs(:has_avatar?).returns(true)
    without = User.new
    without.stubs(:has_avatar?).returns(false)
    
    assert_equal [[with, with], [with, without, without]], User.seperate_users_by_picture([with, without, with, with, without], 2)
  end
  
  #----------------------------------------------------------
  # NAME
  #----------------------------------------------------------
  
  def test_name_is_capitalised_nick
    user = User.new
    user.nick = 'bilbo baggins'
    assert_equal 'Bilbo Baggins', user.name
  end

  def test_name_is_not_capitalised_if_some_capitals_already_specified
    user = User.new
    user.nick = 'bilbo McBaggins'
    assert_equal 'bilbo McBaggins', user.name
  end
  
  def test_name_is_nil_if_nick_is_nil
    assert_equal nil, User.new.name
  end
  
  #----------------------------------------------------------
  # NICK
  #----------------------------------------------------------
  
  def test_nick_cannot_contain_underscores
    user = User.new(:nick => 'Bilbo_Baggins', :email => 'bilbo@baggins.com', :password => 'password', :password_confirmation => 'password')
    assert_equal false, user.valid?
    assert_equal "shouldn't contain underscores. You're allowed to have spaces and capitals, so why not make it something actually pronounceable.", user.errors[:nick]
  end
  
  #----------------------------------------------------------
  # AUTHENTICATE
  #----------------------------------------------------------
  
  def test_authenticate_uses_nick_with_spaces
    User.expects(:find).with(:first, :conditions => ['nick = ? AND hashed_password = ?', 'Bilbo Baggins', 'e04ff0fc6125d092f4948317af9ee245759b9417'])
    User.authenticate('Bilbo Baggins', 'bilbopassword')
  end
  
  def test_authenticate_converts_underscores_in_nick_to_spaces
    User.expects(:find).with(:first, :conditions => ['nick = ? AND hashed_password = ?', 'Bilbo Baggins', 'e04ff0fc6125d092f4948317af9ee245759b9417'])
    User.authenticate('Bilbo_Baggins', 'bilbopassword')
  end
  
  #----------------------------------------------------------
  # CALCULATE FROM PERMALINK
  #----------------------------------------------------------
  
  def test_calculate_permalink_from_nick
    user = User.new
    
    user.nick = 'Fred Jones9*'
    user.calculate_permalink_from_nick
    assert_equal 'fredjones9', user.permalink
  end
  
  #----------------------------------------------------------
  # SPONSOR
  #----------------------------------------------------------
  
  def test_sponsor_defaults_to_false
    assert_equal false, User.new.is_sponsor?
  end
  
  def test_sponsor_is_true_if_user_has_sponsorship
    user = User.new
    user.sponsorship = Sponsorship.new(:user => user)
    assert_equal true, user.is_sponsor?
  end
  
  def test_creating_user_creates_profile
    user = valid_user
    user.save
    assert user.profile
  end
  
  #--------------------------------------------------------
  # DESTROY
  #--------------------------------------------------------
  
  def test_destroying_user_destroys_profile
    user = valid_user
    user.save!
    profile_id = user.profile.id
    user.destroy
    assert_raise(ActiveRecord::RecordNotFound) do
      Profile.find(profile_id)
    end
  end
  
  def test_that_destroying_user_destroys_strip_show_views
    assert StripShowView.exists?(1)
    users(:frodo).destroy
    assert !StripShowView.exists?(1)
  end
  
  def test_that_destroying_user_destroys_interactions_as_actor
    assert Interaction.exists?(1)
    users(:sam).destroy
    assert !Interaction.exists?(1)
  end
  
  def test_that_destroying_user_destroys_interactions_as_subject
    assert Interaction.exists?(1)
    users(:frodo).destroy
    assert !Interaction.exists?(1)
  end

  def test_that_destroying_user_destroys_interaction_counts_as_actor
    assert InteractionCount.exists?(1)
    users(:sam).destroy
    assert !InteractionCount.exists?(1)
  end
  
  def test_that_destroying_user_destroys_interaction_counts_as_subject
    assert InteractionCount.exists?(1)
    users(:frodo).destroy
    assert !InteractionCount.exists?(1)
  end
  
  def test_that_destroying_user_destroys_crushes
    assert Crush.exists?(1)
    users(:pippin).destroy
    assert !Crush.exists?(1)
  end
  
  def test_that_destroying_user_destroys_crushes_as_subject
    assert Crush.exists?(1)
    users(:frodo).destroy
    assert !Crush.exists?(1)
  end

  #----------------------------------------------------------
  # NEW DUMMY FOR
  #----------------------------------------------------------
        
  def test_that_dummy_user_doesnt_publish_profile
    user = User.new_dummy_for('somenewemail@craigambrose.com')
    user.save!
    assert user.profile
    assert !user.profile.published?
  end
  
  protected
  
    def valid_user
      User.new(:nick => 'valid', :email => 'valid@craigambrose.com', :password => 'valid')
    end
  

end
