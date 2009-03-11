require File.dirname(__FILE__) + '/../test_helper'
require 'stripshow_mailer'

class StripshowMailerTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"
  
  fixtures :strip_shows, :strip_photos, :strip_photo_views, :strip_show_views, :users, :email_addresses

  include ActionMailer::Quoting

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
  end
  
  def test_viewed_throws_exception_if_photos_is_empty
    assert_raise ArgumentError, "no photos supplied for email notification" do
      StripshowMailer.create_viewed(users(:frodo), users(:sam), [])
    end
  end
  
  def test_viewed_single_photo
     response = StripshowMailer.create_viewed(users(:frodo), users(:sam), [strip_photos(:sam1)])
     assert_equal 'Someone Viewed Your Photo', response.subject
     assert_equal ['frodo@baggins.com'], response.to
     assert_equal ["noreply@playfulbent.com"], response.from
     assert_equal "multipart/alternative", response.content_type

     text_body = <<ENDTEXT
Hi Frodo,

Sam has viewed one of your strip-show photos, and in the process, they have allowed
you to view one of theirs.

To view the next available photo in this Strip-Show (login required), use the following URL:

http://test.host/stripshows/next_unviewed/1

have fun :)
www.playfulbent.com
ENDTEXT
     assert_equal text_body, response.parts[0].body
     
     html_body = <<ENDHTML
<p>Hi Frodo,</p>

<p>Sam has viewed one of your strip-show photos, and in the process, they have allowed
you to view one of theirs.</p>

To view the next available photo in this Strip-Show (login required):
<a href="http://test.host/stripshows/next_unviewed/1">Click Here</a>

<p>have fun :)<br />
www.playfulbent.com</p>
ENDHTML
    assert_equal html_body, response.parts[1].body
  end


  def test_viewed_multiple_photos
     response = StripshowMailer.create_viewed(users(:frodo), users(:sam), [strip_photos(:sam1), strip_photos(:pippin1)])
     assert_equal 'Someone Viewed Your Photo', response.subject
     assert_equal ['frodo@baggins.com'], response.to
     assert_equal ["noreply@playfulbent.com"], response.from
     assert_equal "multipart/alternative", response.content_type

     text_body = <<ENDTEXT
Hi Frodo,

Sam has viewed one of your strip-show photos, and in the process, they have allowed
you to view several of theirs.

To view the next available photo in each of these Strip-Shows (login required),
use one of the URLs below.

* http://test.host/stripshows/next_unviewed/1
* http://test.host/stripshows/next_unviewed/3

have fun :)
www.playfulbent.com
ENDTEXT
     assert_equal text_body, response.parts[0].body

     html_body = <<ENDHTML
<p>Hi Frodo,</p>

<p>Sam has viewed one of your strip-show photos, and in the process, they have allowed
you to view several of theirs.</p>

To view the next available photo in each of these Strip-Shows (login required),
click on one of the links below.
<ul>
  <li>
    <a href="http://test.host/stripshows/next_unviewed/1">Sam's Sexy Show</a>
  </li>
  <li>
    <a href="http://test.host/stripshows/next_unviewed/3">Pippin's Full Monty</a>
  </li>
</ul>

<p>have fun :)<br />
www.playfulbent.com</p>
ENDHTML
    assert_equal html_body, response.parts[1].body
  end
  
  def test_invite
    invitation = Invitation.new
    invitation.name = 'Radagast'
    invitation.email_address = 'radagast@craigambrose.com'
    invitation.user = users(:pippin)
    invitation.message = "hi radagast\n\nfrom pippin"
    invitation.strip_show = strip_shows(:pippins_show)

    response = StripshowMailer.create_invite(invitation)
    assert_equal 'Somone has invited you to look at their photos', response.subject
    assert_equal ['radagast@craigambrose.com'], response.to
    assert_equal ["noreply@playfulbent.com"], response.from
    assert_equal "multipart/alternative", response.content_type

    text_body = <<ENDTEXT
Hi Radagast,

A friend of yours has uploaded some risque photos of themselves onto the web at playfulbent.com, and they thought you might like to take a look.

They have added the following personal comments for you:

--------------------
hi radagast

from pippin
--------------------

We can't tell you who they are, unless it's clear from the above message, but they knew your email address, so we presume they know you.

You can take a better look at their photos by going to this URL:

http://test.host/strip_photos/16

However, to see the rest of your friend's photos, you will need to show them some of yours. Photo sharing on playful-bent is secure and intimate, and if you're interested you can read more about that on the site.

If you believe that you received this email in error, please let us know at abuse@playfulbent.com and we will give whoever sent this mail a sound spanking.

Kind Regards

Playful-Bent
ENDTEXT
    assert_equal text_body, response.parts[0].body

    html_body = <<ENDHTML
<p>Hi Radagast,</p>
<p>A friend of yours has uploaded some risqu&eacute; photos of themselves onto the web at playfulbent.com,
and they thought you might like to take a look. 

They have added the following personal comments for you:</p>

<div style="background-color: #FFCC33; padding: 6px;">
<p>hi radagast</p>

<p>from pippin</p>
</div>

<p>We can't tell you who they are, unless it's clear from the above message, but they knew your email address, so we presume they know you. The first picture in their photographic strip-show is displayed below, so maybe that will give you
a clue. If it's not displaying, then your mail reader might not be set to display images.</p>

<img alt="Pippin's Full Monty" src="http://test.host/strip_photos/16/show_thumb.jpg" />
<div style="font-weight: bold; font-style: italic;">"Pippin's Full Monty"</div>

<p>You can take a better look at this photo by 
<a href="http://test.host/strip_photos/16">Clicking Here</a>
, however, to see the rest of your friend's
photos, you will need to show them some of yours. Photo sharing on playful-bent is secure and intimate, and
if you're interested you can read more about that on the site.</p>

<p>If you believe that you received this email in error, please let us know at 
<a href="mailto:abuse@playfulbent.com">abuse@playfulbent.com</a> and we will give whoever sent this mail
a sound spanking.</p>

<p>Kind Regards</p>

<p>Playful-Bent</p>
ENDHTML
    assert_equal html_body, response.parts[1].body
  end


  def test_invite_user
    invitation = UserInvitation.new(:recipient => users(:frodo), :user => users(:pippin))

    response = StripshowMailer.create_invite_user(strip_shows(:pippins_show), invitation)
    assert_equal 'Somone has invited you to look at their photos', response.subject
    assert_equal ['frodo@baggins.com'], response.to
    assert_equal ["noreply@playfulbent.com"], response.from
    assert_equal "multipart/alternative", response.content_type

    text_body = <<ENDTEXT
Hi Frodo,

Pippin thought that you might like to take a look at their Playful Bent strip-show, entitled: "Pippin's Full Monty".

To view the first photo in this strip-show, visit the following URL:

http://test.host/strip_photos/16

If you believe that you received this email in error, please let us know at abuse@playfulbent.com and we will give whoever sent this mail a sound spanking.

kind regards,

Playful-Bent
ENDTEXT
    assert_equal text_body, response.parts[0].body

   html_body = <<ENDHTML
<p>Hi Frodo,</p>
<p>Pippin thought that you might like to take a look at their Playful Bent 
strip-show, entitled: <em>"Pippin's Full Monty"</em>.</p> 

<img src="http://test.host/strip_photos/16/show_thumb.jpg" alt="Pippin's Full Monty" />

<p>
  <a href="http://test.host/strip_photos/16">Click Here</a>
  to view the first photo in this strip-photo.
</p>

<p>If you believe that you received this email in error, please let us know at 
<a href="mailto:abuse@playfulbent.com">abuse@playfulbent.com</a> and we will give whoever sent this mail
a sound spanking.</p>

<p>kind regards,</p>

<p>Playful-Bent</p>
ENDHTML
   assert_equal html_body, response.parts[1].body
  end


private
  def read_fixture(action)
    IO.readlines("#{FIXTURES_PATH}/stripshow_mailer/#{action}")
  end

  def encode(subject)
    quoted_printable(subject, CHARSET)
  end
end
