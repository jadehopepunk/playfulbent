class NotificationsMailer < ActionMailer::Base
  helper :application
  
  DEFAULT_FROM = 'noreply@playfulbent.com'
  
  def story_continued(recipient, new_page_version)
    subject "[playfulBENT] Your story has been continued" 
    recipients recipient.email
    from DEFAULT_FROM
    content_type "multipart/alternative" 

    body(:recipient => recipient, :new_page_version => new_page_version)
  end
  
  def new_comment(recipient, comment)
    subject "[playfulBENT] Someone commented on your #{comment.subject_type_name}"
    recipients recipient.email
    from DEFAULT_FROM
    content_type "multipart/alternative"
    
    body(:recipient => recipient, :comment => comment)
  end
  
  def new_comment_reply(comment, reply)
    subject "[playfulBENT] #{reply.user.name} replied to your comment"
    recipients comment.user.email
    from DEFAULT_FROM
    content_type "multipart/alternative"
    
    body(:comment => comment, :reply => reply)
  end  
  
  def admin_warning(comment, params)
    subject "[playfulBENT - #{ENV['RAILS_ENV']}] admin warning"
    recipients 'craig@craigambrose.com'
    from DEFAULT_FROM
    
    body(:comment => comment, :params => params)
  end
  
  def exception_report(area, exception)
    subject "[playfulBENT - #{ENV['RAILS_ENV']}] admin warning"
    recipients 'craig@craigambrose.com'
    from DEFAULT_FROM
    
    body(:area => area, :exception => exception)
  end
  
  def sponsorship_cancelled(sponsorship)
    subject "[playfulBENT] Sponsorship Cancelled"
    recipients sponsorship.user.email
    from DEFAULT_FROM
    
    body(:sponsorship => sponsorship)
  end
  
  def new_sponsorship(sponsorship)
    subject "[playfulBENT] You are now a playful bent sponsor"
    recipients sponsorship.user.email
    from DEFAULT_FROM
    
    body(:sponsorship => sponsorship)  
  end
  
  def new_message(message)
    subject "[playfulBENT] A message from #{message.sender.name}: #{message.subject}"
    recipients message.recipient.email
    from message.sender.playful_email
    
    body(:message => message)
  end
  
  def dare_expired(dare)
    subject '[playfulBENT] Your dare expired'
    recipients dare.creator.email
    from DEFAULT_FROM
    
    body(:dare => dare)
  end
  
  def new_relationship(relationship)
    subject '[playfulBENT] Somebody cares :)'
    recipients relationship.subject.email
    from DEFAULT_FROM
    
    body(:relationship => relationship)
  end
  
  def someone_has_a_crush_on_you(crush)
    subject '[playfulBENT] Someone has a crush on you :)'
    recipients crush.subject.email
    from DEFAULT_FROM
    
    body(:crush => crush)
  end
  
  def new_mutual_crush(crush)
    subject '[playfulBENT] You have a mutual crush!'
    recipients crush.subject.email
    from DEFAULT_FROM
    
    body(:crush => crush)
  end
  
  def new_dare_challenge(dare_challenge)
    subject dare_challenge.subject.dummy? ? "#{dare_challenge.user.name} is offering to do an adult dare of your choice at playfulbent.com" : "[playfulBENT] #{dare_challenge.user.name} is offering to do a dare of your choice"
    recipients dare_challenge.subject.email
    from DEFAULT_FROM
    
    body(:dare_challenge => dare_challenge)
  end
  
  def dare_challenge_rejected(dare_challenge)
    subject "[playfulBENT] #{dare_challenge.subject.name} has turned down your dare challenge"
    recipients dare_challenge.user.email
    from DEFAULT_FROM
    
    body(:dare_challenge => dare_challenge)
  end
  
  def dare_challenge_accepted(dare_challenge)
    subject "[playfulBENT] #{dare_challenge.subject.name} has accepted your dare challenge!"
    recipients dare_challenge.user.email
    from DEFAULT_FROM
    
    body(:dare_challenge => dare_challenge)
  end
  
  def dare_challenge_dare_received(recipient, darer, dare, dare_challenge)
    subject "[playfulBENT] #{darer.name} dares you..."    
    recipients recipient.email
    from DEFAULT_FROM

    body(:recipient => recipient, :darer => darer, :dare => dare, :dare_challenge => dare_challenge)
  end
  
  def dare_rejected(dare_rejection)
    subject "[playfulBENT] #{dare_rejection.user.name} wouldn't do that"
    recipients dare_rejection.darer.email
    from DEFAULT_FROM
    
    body(:dare_rejection => dare_rejection)
  end
  
  def dare_challenge_complete(recipient, dare_challenge)
    other_party = dare_challenge.other_party(recipient)
    
    subject "[playfulBENT] Your dare challenge with #{other_party.name} is complete"
    recipients recipient.email
    from DEFAULT_FROM
    
    body(:recipient => recipient, :other_party => other_party, :dare_challenge => dare_challenge)
  end
  
end
