class GroupsMailer < ActionMailer::Base

  def receive(email)
    yahoo_reader = Yahoo::MailReader.new
    yahoo_reader.parse_email(email)
  end
   
end
