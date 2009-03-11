require File.dirname(__FILE__) + '/../unit_test_helper'

class YahooBounceWarningMailReaderTest < Test::Unit::TestCase
  
  def setup
    @scraper = Yahoo::MockScraper.new(AppConfig.yahoo_scraper_account)
    @reader = Yahoo::BounceWarningMailReader.new(@scraper)
  end
  
  def test_that_unbounce_message_calls_scraper_and_returns_true
    @scraper.expects(:visit_unbounce_url).with('http://groups.yahoo.com/unbounce?adj=317149611,55692&p=1184915947')
    assert @reader.parse_email(bounce_warning)
  end
  
  def test_that_non_unbounce_message_returns_false
    @scraper.expects(:visit_unbounce_url).never
    assert !@reader.parse_email(valid_group_email)
  end
  
  protected

    def valid_group_email
      TMail::Mail.load(RAILS_ROOT + '/test/fixtures/emails/yahoo_mail.txt')
    end
  
    def bounce_warning
      TMail::Mail.load(RAILS_ROOT + '/test/fixtures/emails/yahoo_unbounce_message.txt')
    end
  
  
end