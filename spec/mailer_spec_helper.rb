require File.dirname(__FILE__) + '/model_factory.rb'
require File.dirname(__FILE__) + '/spec_helper.rb'

module MailerSpecHelper
  private

    def read_fixture(mailer, name)
      File.read("#{FIXTURES_PATH}/mailers/#{mailer}/#{name}")
    end
end