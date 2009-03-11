require File.dirname(__FILE__) + '/../test_helper'
require 'notifications_mailer'

class NotificationsMailerTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"
  
  fixtures :relationships, :users, :email_addresses, :relationship_types, :genders, :profiles, :crushes, :dare_challenges, :dare_rejections, :comments, :conversations

  include ActionMailer::Quoting

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
  end
  
  def frodo
    result = User.new
    result.email = "frodo@baggins.com"
    result.stubs(:name).returns("Frodo")
    result.stubs(:permalink).returns("frodo")
    result.stubs(:profile).returns(frodos_profile)
    result.stubs(:id).returns(12)
    result
  end
  
  def frodos_profile
    result = Profile.new
    result.stubs(:to_param).returns('frodo')
  end
  
  def bilbo
    result = User.new
    result.stubs(:name).returns("Bilbo")
    result.stubs(:permalink).returns("bilbo")
    result.stubs(:email).returns("bilbo@baggins.com")
    result.stubs(:gender).returns(Gender.new(:name => 'male'))
    result.stubs(:id).returns(54)
    result
  end
  
  def sample_story
    result = Story.new
    result.stubs(:id).returns(46)
    result.stubs(:title).returns("Craig's First Story")
    result
  end
  
  def page_one
    result = PageVersion.new
    result.stubs(:id).returns(100)
    result.author = bilbo
    result.story = sample_story
    result.text = "I like traffic lights."
    result
  end
  
  def page_two
    result = PageVersion.new
    result.stubs(:id).returns(200)
    result.author = bilbo
    result.story = sample_story
    result.parent = page_one
    result.stubs(:page_number).returns(4)
    result.text = "But only when they're green."
    result
  end
  
  def test_story_continued_plain_text
    response = NotificationsMailer.create_story_continued(frodo, page_two)
    assert_equal '[playfulBENT] Your story has been continued', response.subject
    assert_equal ['frodo@baggins.com'], response.to
    assert_equal ["noreply@playfulbent.com"], response.from
    assert_equal "multipart/alternative", response.content_type
    
    plain_text = <<TEXTBODY
Hi Frodo,

Bilbo has continued a playful-bent story that you asked to be notified about. You can
use the following URL to see this page on the website:

http://test.host/stories/46-craigs-first-story/parent/100/pages

..or, you read it below:

-----------------------------------------------
CRAIG'S FIRST STORY (page 4)

But only when they're green.
-----------------------------------------------

If you received this email in error, please let us know at abuse@playfulbent.com.
To unsubscribe, visit the URL above and un-tick the notification check-boxes.
TEXTBODY
    assert_equal plain_text, response.parts[0].body
  end


  def test_story_continued_html
    response = NotificationsMailer.create_story_continued(frodo, page_two)
    assert_equal '[playfulBENT] Your story has been continued', response.subject
    assert_equal ['frodo@baggins.com'], response.to
    assert_equal ["noreply@playfulbent.com"], response.from
    assert_equal "multipart/alternative", response.content_type

    plain_text = <<TEXTBODY
<html>
	<body>
		<p>Hi Frodo,</p>

		<p>Bilbo has continued a playful-bent story that you
		asked to be notified about. You can 
		<a href="http://test.host/stories/46-craigs-first-story/parent/100/pages">Click Here</a>
		to see this page on the web-site, or read it below.</p>

		<div style="border: 2px solid #CBB5A5; background-color: #F1EAE5; padding: 1em">
      <h1>Craig's First Story (page 4)</h1>
			<p>But only when they're green.</p>
		</div>

		<p>If you received this email in error, please let us know at 
		<a href="mailto:abuse@playfulbent.com">abuse@playfulbent.com</a>.
    To unsubscribe, go <a href="http://test.host/stories/46-craigs-first-story/parent/100/pages">Here</a>
    and un-tick the notification checkboxes.</p>		
	</body>
</html>
TEXTBODY
    assert_equal plain_text, response.parts[1].body
  end
  
  def test_new_comment_on_profile
    profile = Profile.new(:user => frodo)
    
    conversation = Conversation.new(:subject => profile)
    
    comment = Comment.new(:user => bilbo, :conversation => conversation)
    comment.content = "Hey Frodo\n\nI think you look hot, and your feet are furry."
    comment.stubs(:subject_url).returns('http://frodo.test.host')
    
    response = NotificationsMailer.create_new_comment(frodo, comment)
    assert_equal '[playfulBENT] Someone commented on your Profile', response.subject
    assert_equal ['frodo@baggins.com'], response.to
    assert_equal ["noreply@playfulbent.com"], response.from
    assert_equal "multipart/alternative", response.content_type

    plain_text = <<TEXTBODY
Hi Frodo,

Bilbo has posted the a comment on your playfulBENT Profile ("Frodo" at http://frodo.test.host). He wrote:

-----------------------------------------------
Hey Frodo

I think you look hot, and your feet are furry.
-----------------------------------------------

There is currently no way to automatically unsubscribe from these messages (we're working on it). If they're bugging you, please contact jade@playfulbent.com and he will unsubscribe you manually.
TEXTBODY
    assert_equal plain_text, response.parts[0].body
    
    html = <<HTML
<p>Hi Frodo,</p>

<p><a href="http://bilbo.test.host" class="user_link">Bilbo</a> has posted the a comment on your playfulBENT Profile (<a href="http://frodo.test.host">Frodo</a>). He wrote:</p>

<div style="border: 2px solid #CBB5A5; background-color: #F1EAE5; padding: 1em">
  <p>Hey Frodo</p>

<p>I think you look hot, and your feet are furry.</p>
</div>

There is currently no way to automatically unsubscribe from these messages (we're working on it). If they're bugging you, please contact jade@playfulbent.com and he will unsubscribe you manually.
HTML
    assert_equal html, response.parts[1].body
  end
  
  def test_new_comment_on_page_version
    story = Story.new(:title => 'A Nice Story')
    story.stubs(:id).returns(12)
    story.stubs(:new_record?).returns(false)
    
    page_version = PageVersion.new(:story => story)
    page_version.stubs(:id).returns(42)
    page_version.stubs(:new_record?).returns(false)
    
    conversation = Conversation.new(:subject => page_version)
    
    comment = Comment.new(:user => bilbo, :conversation => conversation)
    comment.content = "Hey Frodo\n\nI think you look hot, and your feet are furry."
    
    response = NotificationsMailer.create_new_comment(frodo, comment)
    assert_equal '[playfulBENT] Someone commented on your Page Version', response.subject
    assert_equal ['frodo@baggins.com'], response.to
    assert_equal ["noreply@playfulbent.com"], response.from
    assert_equal "multipart/alternative", response.content_type
    
    plain_text = <<TEXTBODY
Hi Frodo,

Bilbo has posted the a comment on your playfulBENT Page Version ("A Nice Story" at http://test.host/stories/12/parent/0/pages). He wrote:

-----------------------------------------------
Hey Frodo

I think you look hot, and your feet are furry.
-----------------------------------------------

There is currently no way to automatically unsubscribe from these messages (we're working on it). If they're bugging you, please contact jade@playfulbent.com and he will unsubscribe you manually.
TEXTBODY
    assert_equal plain_text, response.parts[0].body


    html = <<HTML
<p>Hi Frodo,</p>

<p><a href="http://bilbo.test.host" class="user_link">Bilbo</a> has posted the a comment on your playfulBENT Page Version (<a href="http://test.host/stories/12/parent/0/pages">A Nice Story</a>). He wrote:</p>

<div style="border: 2px solid #CBB5A5; background-color: #F1EAE5; padding: 1em">
  <p>Hey Frodo</p>

<p>I think you look hot, and your feet are furry.</p>
</div>

There is currently no way to automatically unsubscribe from these messages (we're working on it). If they're bugging you, please contact jade@playfulbent.com and he will unsubscribe you manually.
HTML
    assert_equal html, response.parts[1].body    
  end
  
  def test_reply_to_comment
    conversations(:about_profile_one).update_attribute :title_override, 'stuff'
    response = NotificationsMailer.create_new_comment_reply(comments(:two), comments(:two_one))
    assert_equal '[playfulBENT] Pippin replied to your comment', response.subject
    assert_equal ['frodo@baggins.com'], response.to
    assert_equal ["noreply@playfulbent.com"], response.from
    assert_equal "multipart/alternative", response.content_type

    plain_text = <<TEXTBODY
Hi Frodo,

Pippin has replied to your comment in the conversation about "stuff" on Playful Bent. He wrote:

-----------------------------------------------
That sucks
-----------------------------------------------

You can reply to this at: http://test.host/conversations/2/comments/new?parent_id=3

There is currently no way to automatically unsubscribe from these messages (we're working on it). If they're bugging you, please contact jade@playfulbent.com and he will unsubscribe you manually.
TEXTBODY
    assert_equal plain_text, response.parts[0].body

    html = <<HTML
<p>Hi Frodo,</p>

<p><a href="http://pippin.test.host" class="user_link">Pippin</a> has replied to your comment in the conversation about "<a href="http://test.host/conversations/2/comments">stuff</a>" on Playful Bent. He wrote:</p>

<div style="border: 2px solid #CBB5A5; background-color: #F1EAE5; padding: 1em">
  <p>That sucks</p>
</div>

<p>You can reply to this by <a href="http://test.host/conversations/2/comments/new?parent_id=3">clicking here</a>.</p>

<p>There is currently no way to automatically unsubscribe from these messages (we're working on it). If they're bugging you, please contact <a href="mailto:jade@playfulbent.com">jade@playfulbent.com</a> and he will unsubscribe you manually.</p>
HTML
    assert_equal html, response.parts[1].body
  end
  
  def test_admin_warning
    params = {'id' => '5', 'value' => '$5'}
    response = NotificationsMailer.create_admin_warning("some text", params)
    
    assert_equal '[playfulBENT - test] admin warning', response.subject
    assert_equal ['craig@craigambrose.com'], response.to
    assert_equal ["noreply@playfulbent.com"], response.from

    plain_text = <<PLAINTEXT
Hi Craig,

Warning from playful-bent:

some text

Dump of params:

{"id"=>"5", "value"=>"$5"}
PLAINTEXT
  assert_equal plain_text, response.body
  end
  
  def test_sponsorship_cancelled
    user = frodo
    sponsorship = Sponsorship.new(:user => frodo)
    
    response = NotificationsMailer.create_sponsorship_cancelled(sponsorship)
    
    assert_equal '[playfulBENT] Sponsorship Cancelled', response.subject
    assert_equal ['frodo@baggins.com'], response.to
    assert_equal ["noreply@playfulbent.com"], response.from
    
    plain_text = <<PLAINTEXT
Hi Frodo,

Your playfulBENT sponsorship has been cancelled. Thanks for having supported us, and we hope you'll continue to enjoy the site.

Andale & Jade
PLAINTEXT
    assert_equal plain_text, response.body
  end
  
  def test_new_sponsorship
    user = frodo
    sponsorship = Sponsorship.new(:user => frodo)

    response = NotificationsMailer.create_new_sponsorship(sponsorship)

    assert_equal '[playfulBENT] You are now a playful bent sponsor', response.subject
    assert_equal ['frodo@baggins.com'], response.to
    assert_equal ["noreply@playfulbent.com"], response.from

    plain_text = <<PLAINTEXT
Hi Frodo,

You are now a playful bent sponsor. We greatly appreciate your help in making the site possible, and we hope you'll continue to enjoy the features we plan to add.

big hugs,

Andale & Jade
PLAINTEXT
    assert_equal plain_text, response.body
  end
  
  def test_new_message
    message = Message.new(:recipient => frodo, :sender => bilbo, :subject => 'Are you coming to my birthday?', :body => "Hey there Frodo\n\nI'm hoping that you're going to come to my birthday. It will be really good.\n\nlove\nBilbo")
    response = NotificationsMailer.create_new_message(message)

    assert_equal '[playfulBENT] A message from Bilbo: Are you coming to my birthday?', response.subject
    assert_equal ['frodo@baggins.com'], response.to
    assert_equal ["bilbo@playfulbent.com"], response.from

    plain_text = <<PLAINTEXT
Hi Frodo,

Here's a private message from Bilbo on Playful Bent:

-----------------------------------------------
Hey there Frodo

I'm hoping that you're going to come to my birthday. It will be really good.

love
Bilbo
-----------------------------------------------

You can now reply to the messages by email. Just hit reply in your mail program, and delete this quoted text.

Your messages are also listed on your profile page:
http://test.host/users/12-frodo/messages

If you received this email in error, please let us know at abuse@playfulbent.com.
PLAINTEXT
    assert_equal plain_text, response.parts[0].body
    
    html_text = <<HTML_TEXT
<html>
	<body>
		<p>Hi Frodo,</p>

		<p>Here's a private message from <a href="http://bilbo.test.host">Bilbo</a> on Playful Bent:</p>

		<div style="border: 2px solid #CBB5A5; background-color: #F1EAE5; padding: 1em">
			<p>Hey there Frodo</p>

<p>I'm hoping that you're going to come to my birthday. It will be really good.</p>

<p>love
<br />Bilbo</p>
		</div>

    <p>You can now reply to the messages by email. Just hit reply in your mail program, and delete this quoted text.</p>

		<p>Your messages are also listed on your <a href="http://test.host/users/12-frodo/messages">Playful Bent profile.</a></p>

		<p>If you received this email in error, please let us know at <a href="mailto:abuse@playfulbent.com">abuse@playfulbent.com</a>.</p>
	</body>
</html>
HTML_TEXT
    assert_equal html_text, response.parts[1].body
  end

  def test_dare_expired
    dare = Dare.new(:creator => frodo, :request => 'I dare you to take off your clothes in a subway station and do the chicken dance.')
    dare.stubs(:id).returns(42)
    dare.stubs(:new_record?).returns(false)
    response = NotificationsMailer.create_dare_expired(dare)

    assert_equal '[playfulBENT] Your dare expired', response.subject
    assert_equal ['frodo@baggins.com'], response.to
    assert_equal ["noreply@playfulbent.com"], response.from
    
    plain_text = <<PLAINTEXT
Hi Frodo,

You posted the following dare on Playful Bent:

"I dare you to take off your clothes in a subway station and do the chicken dance."

It's been sitting there for three weeks and no one has tried it. So, we're going to move it off the front page, and give some other dares a shot.

Feel free to try another one. If people aren't trying your dares, then maybe they are too confronting, or too complicated. Try something simpler. Or, it could just be bad luck. Either way, we really appreciate your contribution to the site.

If someone does want to try your dare later, they can still do so. A page for your dare is available here:

http://test.host/dares/42

If you received this email in error, please let us know at abuse@playfulbent.com.
PLAINTEXT
    assert_equal plain_text, response.parts[0].body

    html_text = <<HTML_TEXT
<html>
  <body>
    <p>Hi Frodo,</p>

    <p>You posted the following dare on <a href="http://www.playfulbent.com">Playful Bent</a>:<p>

    <p><em>"I dare you to take off your clothes in a subway station and do the chicken dance."</em></p>

    <p>It's been sitting there for three weeks and no one has tried it. So, we're going to move it off the front page, and give some other dares a shot.</p>

    <p>Feel free to try another one. If people aren't trying your dares, then maybe they are too confronting, or too complicated. Try something simpler. Or, it could just be bad luck. Either way, we really appreciate your contribution to the site.</p>

    <p>If someone does want to try your dare later, they can still do so. A page for your dare is available here:</p>

    <p><a href="http://test.host/dares/42">http://test.host/dares/42</a></p>

    <p>If you received this email in error, please let us know at <a href="mailto:abuse@playfulbent.com">abuse@playfulbent.com</a>.</p>
  </body>
</html>
HTML_TEXT
    assert_equal html_text, response.parts[1].body
  end

  def test_dare_expired
    response = NotificationsMailer.create_new_relationship(relationships(:aaron_is_sams_friend))

    assert_equal '[playfulBENT] Somebody cares :)', response.subject
    assert_equal ['aaron@example.com'], response.to
    assert_equal ["noreply@playfulbent.com"], response.from
    
    plain_text = <<PLAIN_TEXT
Hi Aaron,

Just a quick note to let you know that Sam has listed you on playful bent as his friend.

More details on Sam's friends page here:
http://test.host/users/1003-sam/relationships

cheers,

Playful Bent
PLAIN_TEXT

    assert_equal plain_text, response.parts[0].body

    html_text = <<HTML_TEXT
<p>Hi Aaron,</p>

<p>Just a quick note to let you know that <a href="http://sam.test.host">Sam</a> has listed you on playful bent as his friend.</p>

<p>More details on <a href="http://test.host/users/1003-sam/relationships">Sam's friends page</a>.</p>

<p>cheers,</p>

<p>Playful Bent</p>
HTML_TEXT
    assert_equal html_text, response.parts[1].body

  end
  
  def test_somone_has_a_crush_on_you
    response = NotificationsMailer.create_someone_has_a_crush_on_you(crushes(:pippin_likes_frodo))

    assert_equal '[playfulBENT] Someone has a crush on you :)', response.subject
    assert_equal ['frodo@baggins.com'], response.to
    assert_equal ["noreply@playfulbent.com"], response.from

    plain_text = <<PLAIN_TEXT
Hi Frodo,

Somone on Playful Bent has a crush on you. It's a secret crush, so we can't tell you who it is, but this mystery person has written down their fantasy about you and it will be revealed to you only if you have a crush on them too.

The only way that this can happen is if you find the people who you are attracted to on Playful Bent and create crushes on them. There's a link for this that says "Create a secret crush" on everyone's profile page, or you can visit:

http://test.host/crushes/new

If the feeling isn't mutual, you can just ignore this message, and they will never know or be offended.

cheers,

Playful Bent
PLAIN_TEXT

    assert_equal plain_text, response.parts[0].body
  end
  
  def test_someone_has_a_crush_on_dummy_user
    response = NotificationsMailer.create_someone_has_a_crush_on_you(crushes(:pippin_likes_dummy))

    assert_equal '[playfulBENT] Someone has a crush on you :)', response.subject
    assert_equal ['dummy@craigambrose.com'], response.to
    assert_equal ["noreply@playfulbent.com"], response.from

    plain_text = <<PLAIN_TEXT
Hi there,

Somone on Playful Bent has a crush on you. It's a secret crush, so we can't tell you who it is, but this mystery person has written down their fantasy about you and it will be revealed to you only if you have a crush on them too.

The only way that this can happen is if you find the people who you are attracted to on Playful Bent and create crushes on them. There's a link for this that says "Create a secret crush" on everyone's profile page, or you can visit:

http://test.host/crushes/new

If the feeling isn't mutual, you can just ignore this message, and they will never know or be offended.

Playful Bent is an adult social networking site. This message has been sent to you because one of our users entered your email address for their secret crush. Your address is not stored at wont be used for anything further by us. If you'd like to sign up (it's free) then you'll only be able to who sent this crush if you use the email address that this was sent to (dummy@craigambrose.com) as the address on the playful bent signup page (http://test.host/session/new).

cheers,

Playful Bent
PLAIN_TEXT

    assert_equal plain_text, response.parts[0].body
  end
  
  def test_new_mutual_crush
    response = NotificationsMailer.create_new_mutual_crush(crushes(:quentin_likes_aaron))

    assert_equal '[playfulBENT] You have a mutual crush!', response.subject
    assert_equal ['aaron@example.com'], response.to
    assert_equal ["noreply@playfulbent.com"], response.from
    
    plain_text = <<PLAIN_TEXT
Hi Aaron,

Someone that you have a crush on feels the same way!

We could tell you who it is, but that'd spoil the anticipation. Instead, you should go straight here:

http://test.host/crushes/3

This may or may not be safe for work. It contains profile pictures, and probably some steamy language.

have fun,

Playful Bent
PLAIN_TEXT

    assert_equal plain_text, response.parts[0].body
  end
  
  def test_new_dare_challenge
    response = NotificationsMailer.create_new_dare_challenge(dare_challenges(:sam_challenges_frodo))

    assert_equal "[playfulBENT] Sam is offering to do a dare of your choice", response.subject
    assert_equal ['frodo@baggins.com'], response.to
    assert_equal ["noreply@playfulbent.com"], response.from

    plain_text = <<PLAIN_TEXT
Hi Frodo,

You have been challenged by Sam to a two-way Dare challenge.

If you agree, then you get to make up a dare for Sam to perform, and he gets to make up one for you. However, you get to choose if you want the dare to be flirty, sexual, or downright kinky.

To find out more, and decide whether you want to accept or refuse, you can go here:
http://test.host/dare_challenges/1

have fun,

Playful Bent
PLAIN_TEXT

    assert_equal plain_text, response.parts[0].body
  end
  
  def test_new_dare_challenge_with_dummy_user
    response = NotificationsMailer.create_new_dare_challenge(dare_challenges(:sam_challenges_dummy))

    assert_equal "Sam is offering to do an adult dare of your choice at playfulbent.com", response.subject
    assert_equal ['dummy@craigambrose.com'], response.to
    assert_equal ["noreply@playfulbent.com"], response.from

    plain_text = <<PLAIN_TEXT
Hi there,

You have been challenged by Sam to a two-way Dare challenge.

If you agree, then you get to make up a dare for Sam to perform, and he gets to make up one for you. However, you get to choose if you want the dare to be flirty, sexual, or downright kinky.

To find out more, and decide whether you want to accept or refuse, you can go here:
http://test.host/dare_challenges/6

Since you haven't used Playful Bent before, you'll be asked to sign up first. It's free, and involves no spam and no obligations. Them, you can get down to the business of having fun with Sam.

have fun,

Playful Bent
PLAIN_TEXT

    assert_equal plain_text, response.parts[0].body
  end
  
  def test_dare_challenge_rejected
    response = NotificationsMailer.create_dare_challenge_rejected(dare_challenges(:frodo_rejects_sams_challenge))
    
    assert_equal "[playfulBENT] Frodo has turned down your dare challenge", response.subject
    assert_equal ['sam@craigambrose.com'], response.to
    assert_equal ["noreply@playfulbent.com"], response.from
    
    plain_text = <<PLAIN_TEXT
Hi Sam,

Unfortunately, Frodo has turned down you dare challenge.

Don't be disheartened, there are plenty of other exciting things to do on playful bent, and plenty of other exciting people to do them with.

kind regards,

Playful Bent
PLAIN_TEXT

    assert_equal plain_text, response.parts[0].body
  end
  
  def test_dare_challenge_accepted
    response = NotificationsMailer.create_dare_challenge_accepted(dare_challenges(:sam_challenges_frodo_with_response))

    assert_equal "[playfulBENT] Frodo has accepted your dare challenge!", response.subject
    assert_equal ['sam@craigambrose.com'], response.to
    assert_equal ["noreply@playfulbent.com"], response.from

    plain_text = <<PLAIN_TEXT
Hi Sam,

Frodo has accepted your dare challenge!

This means that you can now describe a dare for him to carry out.

To do so, go here:
http://test.host/dare_challenges/2

have fun,

Playful Bent
PLAIN_TEXT

    assert_equal plain_text, response.parts[0].body
  end
  
  def test_dare_challenge_dare_received
    response = NotificationsMailer.create_dare_challenge_dare_received(users(:sam), users(:frodo), "Eat my shorts!", dare_challenges(:sam_challenges_frodo_with_dares))
    
    assert_equal "[playfulBENT] Frodo dares you...", response.subject
    assert_equal ['sam@craigambrose.com'], response.to
    assert_equal ["noreply@playfulbent.com"], response.from
    
    plain_text = <<PLAIN_TEXT
Hi Sam,

You and Frodo have both agreed to a "flirty" Dare Challenge on Playful Bent. Here's the dare that Frodo has written for you to perform:

--------
Eat my shorts!
--------

You need to go away and do this, and then upload a photo of the act, and a short description, to the following page:

http://test.host/dare_challenges/4

There is also more information on that page (above) about your privacy, and what to do if you really don't want to do this dare. Remember, dares should not cause any harm to you or your relationships with others.
  
have fun,

Playful Bent
PLAIN_TEXT

    html = <<HTML
<html>
	<body>
		<p>Hi Sam,</p>

		<p>You and Frodo have both agreed to a "flirty" Dare Challenge on Playful Bent. Here's the dare that Frodo has written for you to perform:</p>

		<div style="border: 2px solid #CBB5A5; background-color: #F1EAE5; padding: 1em">
			<p>Eat my shorts!</p>
		</div>

		<p>You need to go away and do this, and then upload a photo of the act, and a short description, to the following page:</p>

		<p><a href="http://test.host/dare_challenges/4">http://test.host/dare_challenges/4</a></p>

		<p>There is also more information on that page (above) about your privacy, and what to do if you really don't want to do this dare. Remember, dares should not cause any harm to you or your relationships with others.</p>

		<p>have fun,</p>

		<p>Playful Bent</p>
	</body>
</html>
HTML

    assert_equal plain_text, response.parts[0].body
    assert_equal html, response.parts[1].body
  end
  
  def test_dare_rejected
    response = NotificationsMailer.create_dare_rejected(dare_rejections(:frodo_rejected_dare))
    
    assert_equal "[playfulBENT] Frodo wouldn't do that", response.subject
    assert_equal ['sam@craigambrose.com'], response.to
    assert_equal ["noreply@playfulbent.com"], response.from
    
    plain_text = <<PLAIN_TEXT
Hi Sam,

Frodo wouldn't carry out your dare. You can find out more info, and give him another dare here:
http://test.host/dare_challenges/5

have fun,

Playful Bent
PLAIN_TEXT

    assert_equal plain_text, response.parts[0].body
  end
  
  def test_dare_challenge_complete
    response = NotificationsMailer.create_dare_challenge_complete(users(:sam), dare_challenges(:sam_challenges_frodo_with_dares))
    
    assert_equal "[playfulBENT] Your dare challenge with Frodo is complete", response.subject
    assert_equal ['sam@craigambrose.com'], response.to
    assert_equal ["noreply@playfulbent.com"], response.from
    
    plain_text = <<PLAIN_TEXT
Hi Sam,

You and Frodo have both completed your dares for your Dare Challenge.

The results are here:
http://test.host/dare_challenges/4

have fun,

Playful Bent
PLAIN_TEXT

    assert_equal plain_text, response.parts[0].body
  end

private
  def read_fixture(action)
    IO.readlines("#{FIXTURES_PATH}/notifications_mailer/#{action}")
  end

  def encode(subject)
    quoted_printable(subject, CHARSET)
  end
end
