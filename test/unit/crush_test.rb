require File.dirname(__FILE__) + '/../test_helper'

class CrushTest < Test::Unit::TestCase
  fixtures :crushes, :users, :email_addresses, :interactions

  #-------------------------------------------------------------
  # IS RECIPROCATED
  #-------------------------------------------------------------

  def test_is_reciprocated
    assert !crushes(:pippin_likes_frodo).is_reciprocated?
    assert crushes(:quentin_likes_aaron).is_reciprocated?
  end
  
  #-------------------------------------------------------------
  # CREATE
  #-------------------------------------------------------------

  def test_that_creating_reciprocated_crush_creates_interaction
    assert !InteractionMutualCrush.exists?(:actor_id => users(:frodo).id, :subject_id => users(:pippin).id)
    assert !InteractionMutualCrush.exists?(:actor_id => users(:pippin).id, :subject_id => users(:frodo).id)

    new_reciprocated_crush.save!
    
    assert InteractionMutualCrush.exists?(:actor_id => users(:frodo).id, :subject_id => users(:pippin).id)
    assert InteractionMutualCrush.exists?(:actor_id => users(:pippin).id, :subject_id => users(:frodo).id)
  end

  def test_that_creating_not_reciprocated_crush_doesnt_create_interaction
    new_non_reciprocated_crush.save!
    
    assert !InteractionMutualCrush.exists?(:actor_id => users(:frodo).id, :subject_id => users(:aaron).id)
    assert !InteractionMutualCrush.exists?(:actor_id => users(:aaron).id, :subject_id => users(:frodo).id)
  end
  
  def test_that_creating_non_reciprocated_crush_sends_anonymous_email
    crush = new_non_reciprocated_crush
    NotificationsMailer.expects(:deliver_someone_has_a_crush_on_you).with(crush)
    crush.save!
  end
  
  def test_that_creating_non_reciprocated_crush_handles_emaiL_error
    crush = new_non_reciprocated_crush
    NotificationsMailer.expects(:deliver_someone_has_a_crush_on_you).with(crush).raises(Net::SMTPSyntaxError)
    crush.save!
  end
  
  def test_that_creating_reciprocated_crush_doesnt_send_anonymous_email
    crush = new_reciprocated_crush
    NotificationsMailer.expects(:deliver_someone_has_a_crush_on_you).with(crush).never
    crush.save!
  end
  
  def test_that_creating_reciprocated_crush_sends_mutual_email
    crush = new_reciprocated_crush
    NotificationsMailer.expects(:deliver_new_mutual_crush).with(crush)
    crush.save!
  end

  def test_that_creating_reciprocated_crush_handles_mutual_email_error
    crush = new_reciprocated_crush
    NotificationsMailer.expects(:deliver_new_mutual_crush).with(crush).raises(Net::SMTPSyntaxError)
    crush.save!
  end

  def test_that_creating_non_reciprocated_crush_doesnt_send_mutual_email
    crush = new_non_reciprocated_crush
    NotificationsMailer.expects(:deliver_new_mutual_crush).with(crush).never
    crush.save!
  end
  
  protected
  
    def new_reciprocated_crush
      crush = Crush.new(:fantasy => 'stuff')
      crush.user = users(:frodo)
      crush.subject = users(:pippin)
      crush
    end  
  
    def new_non_reciprocated_crush
      crush = Crush.new(:fantasy => 'stuff')
      crush.user = users(:frodo)
      crush.subject = users(:aaron)
      crush
    end
  
end
