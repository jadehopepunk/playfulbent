# == Schema Information
#
# Table name: base_dare_responses
#
#  id                :integer(4)      not null, primary key
#  user_id           :integer(4)
#  dare_id           :integer(4)
#  created_on        :datetime
#  description       :text(16777215)
#  photo             :string(255)
#  type              :string(255)
#  dare_challenge_id :integer(4)
#

require File.dirname(__FILE__) + '/../test_helper'

class DareResponseTest < Test::Unit::TestCase
  fixtures :dares, :base_dare_responses, :users, :email_addresses
  
  def test_creating_response_ensures_perform_dare_interaction_is_created
    InteractionPerformDare.expects(:ensure_created).with(users(:aaron), users(:sam))
    
    response = DareResponse.new(:dare => dares(:banana), :user => users(:aaron), :description => 'fish')
    response.save
  end

  def test_destroying_response_ensures_perform_dare_interaction_is_still_valid
    response = DareResponse.new(:dare => dares(:banana), :user => users(:aaron), :description => 'fish')
    response.save

    InteractionPerformDare.expects(:ensure_still_valid).with(users(:aaron), users(:sam))
    response.destroy
  end

  def test_creating_response_ensures_have_dare_performed_interaction_is_created
    InteractionHaveDarePerformed.expects(:ensure_created).with(users(:sam), users(:aaron))
    
    response = DareResponse.new(:dare => dares(:banana), :user => users(:aaron), :description => 'fish')
    response.save
  end

  def test_destroying_response_ensures_have_dare_performed_interaction_is_still_valid
    response = DareResponse.new(:dare => dares(:banana), :user => users(:aaron), :description => 'fish')
    response.save

    InteractionHaveDarePerformed.expects(:ensure_still_valid).with(users(:sam), users(:aaron))
    response.destroy
  end
  
  def test_creating_response_marks_dare_as_responded_to
    response = DareResponse.new(:dare => dares(:not_responded_to), :user => users(:aaron), :description => 'fish')    
    response.save
    
    dare = response.dare.reload
    assert_equal true, dare.responded_to
  end
  
  def test_cant_save_with_no_photo_or_description
    response = DareResponse.new(:dare => dares(:not_responded_to), :user => users(:aaron))    
    assert_equal false, response.save
  end
  
end
