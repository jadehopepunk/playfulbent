require File.dirname(__FILE__) + '/../unit_test_helper'

class YahooMailReaderTest < Test::Unit::TestCase
  fixtures :mailing_list_messages, :groups, :yahoo_profiles
  
  def setup
    @reader = Yahoo::MailReader.new
  end
  
  #----------------------------------------------------------
  # PARSE EMAIL
  #----------------------------------------------------------
  
  def test_new_message_from_email
    message = @reader.parse_email(valid_group_email)
    
    assert message
    assert message.raw_email
    assert_equal 'craig@craigambrose.com', message.sender_address
    assert_equal 'Lorem Ipsum', message.subject
    assert_equal lipsum, message.text_body
    assert_equal '<f791aq+k6qf@eGroups.com>', message.message_identifier
    assert_equal groups(:craigs_playground), message.group
    assert_equal yahoo_profiles(:emlyn), message.sender_external_profile
    assert_equal Time.parse('Sat, 14 Jul 2007 11:19:54 +1200'), message.received_at
    assert message.valid?
    assert !message.new_record?
  end
  
  def test_removes_subject_group_label
    email = valid_group_email
    email.subject = '(craigsplayground) some stuff'

    message = @reader.parse_email(email)
    
    assert_equal 'some stuff', message.subject
  end
  
  def test_new_from_reply_email
    parent_message = @reader.parse_email(valid_group_email)
    parent_message.save
    message = @reader.parse_email(reply_mail)
    
    assert message
    assert_equal 'playfulbent_test_collector@portallus.com', message.sender_address
    assert_equal 'Re: Lorem Ipsum', message.subject
    assert_equal '<f79l9n+r8np@eGroups.com>', message.message_identifier
    assert_equal parent_message, message.parent
  end
  
  def test_multipart_mixed
    message = @reader.parse_email(multipart_mixed)

    expected_text = <<TEXT
If I could have just one wish,
I would wish to wake up everyday
to the sound of your breath on my neck,
the warmth of your lips on my cheek,
the touch of your fingers on my skin,
and the feel of your heart beating with mine...
Knowing that I could never find that feeling
with anyone other than you.

*- CLICK HERE <http://www.univez.com/chatdating.html> -*
TEXT
    expected_text.rstrip!

    assert_equal expected_text, message.text_body
  end
  
  def test_that_wont_parse_the_same_email_twice
    message = @reader.parse_email(valid_group_email)
    message.save
    
    assert_equal nil, @reader.parse_email(valid_group_email)
  end
  
  def test_that_finds_message_id
    message = @reader.parse_email(load_email(:blank_id))
    
    assert message.save
  end
  
  protected
  
    def valid_group_email
      load_email :yahoo_mail
    end
    
    def reply_mail
      load_email :yahoo_mail2
    end
    
    def multipart_mixed
      load_email :yahoo_multipart_mixed
    end
    
    def load_email(name)
      TMail::Mail.load(RAILS_ROOT + "/test/fixtures/emails/#{name}.txt")
    end
    
    def lipsum
      File.open(RAILS_ROOT + '/test/fixtures/lipsum.txt').read
    end

end