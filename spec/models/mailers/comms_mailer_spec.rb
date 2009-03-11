require File.dirname(__FILE__) + '/../../mailer_spec_helper.rb'

# describe 'The CommsMailer mailer' do
#   FIXTURES_PATH = File.dirname(__FILE__) + '/../../fixtures'
#   CHARSET = 'utf-8'
# 
#   fixtures :users
# 
#   include MailerSpecHelper
#   include ActionMailer::Quoting
# 
#   setup do
#     @expected = TMail::Mail.new
#     @expected.set_content_type 'text', 'plain', { 'charset' => CHARSET }
#     @expected.mime_version = '1.0'
#     @model_factory = ModelFactoryIncluder::ModelFactory.new
#     
#     @andale = @model_factory.user(:nick => 'Andale', :email => 'andale@gmail.com')
#     @email = mock(Email, 
#       :recipient => @andale, 
#       :text_body => "Hi Andale,\n\nI think you are cute.", 
#       :subject => 'Stuff',
#       :sender_address => 'andale@gmail.com',
#       :id => 43, 
#       :to_param => '43')
#   end
# 
#   it 'should send passthrough email' do
#     @expected.subject = 'Stuff'
#     @expected.body = "Hi Andale,\n\nI think you are cute."
#     @expected.from = 'andale@gmail.com'
#     @expected.to = 'craig@craigambrose.com'
# 
#     CommsMailer.create_passthrough(@email, 'craig@craigambrose.com').encoded.should == @expected.encoded
#   end
#   
#   it 'should send verify new sender email' do
#     result = CommsMailer.create_verify_new_sender(@email, 'craigambrose@gmail.com', 'Craig Ambrose')
#     result.subject.should == "Pick a username to contact Andale"
#     result.to.should == ['craigambrose@gmail.com']
#     result.from.should == ['noreply@playfulbent.com']
#     result.body.should == read_fixture('comms_mailer', 'verify_new_sender.txt')
#   end
#   
# end