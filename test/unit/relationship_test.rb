# == Schema Information
#
# Table name: relationships
#
#  id                   :integer(4)      not null, primary key
#  user_id              :integer(4)
#  subject_id           :integer(4)
#  relationship_type_id :integer(4)
#  created_at           :datetime
#  description          :text
#

require File.dirname(__FILE__) + '/../test_helper'

class RelationshipTest < Test::Unit::TestCase
  fixtures :relationships, :relationship_types, :users, :email_addresses, :profiles, :genders

  def test_name_initialises_relationship_type
    rel = Relationship.new
    rel.user = users(:sam)
    rel.name = 'brother'
    
    assert_equal 'brother', rel.name
    assert rel.relationship_type
    assert rel.relationship_type.new_record?
    assert_equal 'brother', rel.relationship_type.name
    assert_equal users(:sam).id, rel.relationship_type.user_id
  end

  def test_creating_relationship_sends_email
    rel = valid_relationship
    NotificationsMailer.expects(:deliver_new_relationship).with(rel)

    rel.save!
  end

  def test_reciprocal_returns_reciprocal_relationship
    assert_equal [relationships(:frodo_likes_pippin)], relationships(:pippin_likes_frodo).reciprocals
    assert_equal [relationships(:pippin_likes_frodo)], relationships(:frodo_likes_pippin).reciprocals
  end

  def test_is_reciprocated
    assert !relationships(:aaron_is_sams_friend).is_reciprocated?
    assert relationships(:pippin_likes_frodo).is_reciprocated?
  end

  def test_creating_relationship_ensures_is_friend_of_interaction_is_created
    InteractionIsFriendOf.expects(:ensure_created).with(users(:bob), users(:frodo))
    relationship = Relationship.new(:subject => users(:bob), :relationship_type => relationship_types(:frodos_friends))
    relationship.user = users(:frodo)
    relationship.save!
  end
  
  def test_destroying_relationship_ensures_is_friend_of_interaction_is_still_valid
    relationship = Relationship.new(:subject => users(:bob), :relationship_type => relationship_types(:frodos_friends))
    relationship.user = users(:frodo)
    relationship.save!

    InteractionIsFriendOf.expects(:ensure_still_valid).with(users(:bob), users(:frodo))
    relationship.destroy
  end

  def test_creating_relationship_ensures_friends_with_interaction_is_created
    InteractionFriendsWith.expects(:ensure_created).with(users(:frodo), users(:bob))
    relationship = Relationship.new(:subject => users(:bob), :relationship_type => relationship_types(:frodos_friends))
    relationship.user = users(:frodo)
    relationship.save!
  end
  
  def test_destroying_relationship_ensures_friends_with_interaction_is_still_valid
    relationship = Relationship.new(:subject => users(:bob), :relationship_type => relationship_types(:frodos_friends))
    relationship.user = users(:frodo)
    relationship.save!

    InteractionFriendsWith.expects(:ensure_still_valid).with(users(:frodo), users(:bob))
    relationship.destroy
  end

  protected
  
    def valid_relationship
      rel = Relationship.new
      rel.user = users(:sam)
      rel.attributes = {:subject => users(:longbob), :name => 'sister'}
      rel
    end
  
end
