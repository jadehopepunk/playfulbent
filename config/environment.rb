# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require 'plugins/app_config/lib/configuration'

RAILS_GEM_VERSION = '2.1.0' unless defined? RAILS_GEM_VERSION

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence those specified here
  
  # Skip frameworks you're not going to use
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug
  require 'hodel_3000_compliant_logger'
  config.logger = Hodel3000CompliantLogger.new(config.log_path)  

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake create_sessions_table')
  config.action_controller.session_store = :active_record_store

  # Enable page/fragment caching by setting a file-based store
  # (remember to create the caching directory and make it readable to the application)
  # config.action_controller.fragment_cache_store = :file_store, "#{RAILS_ROOT}/cache"

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # Use Active Record's schema dumper instead of SQL when creating the test database
  # (enables use of different database adapters for development and test environments)
  # config.active_record.schema_format = :ruby

  # See Rails::Configuration for more options
  
  # YAHOO INTEGRATION
  config.app_config.yahoo_scraper_account = {:username => 'playfulbent_test_bot', :password => 'bootlace'}
  config.app_config.mailing_list_collector_address = 'playfulbent_test_collector@portallus.com'
  config.app_config.mailing_list_collector_password = 'bootlace'
  config.app_config.mailing_list_collector_pop_host = 'mail.portallus.com'
  
  # PAYPAL INTEGRATION
  config.app_config.paypal_url = 'https://www.sandbox.paypal.com/cgi-bin/webscr'
  config.app_config.paypal_email = 'payments@playfulbent.com'

  # GOOGLE MAPS
  config.app_config.google_maps_key = 'ABQIAAAAeBPm_-KwgwjbZtYJENq_NxT2gEarVg5Z7ax6cK4j8CNFWrqRgRSqDzTXjPkqz80sBYjUYwDBaombxA'
  
  # FLICKR
  config.app_config.flickr_api_key = '2a8764233e0d991553857f5f5d0490ab'
  config.app_config.flickr_shared_secret = '7c7e089b1f6a298d'
  
  config.app_config.support_address = 'craig@craigambrose.com'
  
end

# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Include your application configuration below
require 'rss/2.0'
require 'rss/content'
require 'open-uri'
require 'monkey_patches'
require 'mail_extensions'

ExceptionNotifier.email_prefix = "[Playfulbent Error - #{ENV['RAILS_ENV']}]"
ExceptionNotifier.exception_recipients = %w(craig@craigambrose.com)

WhiteListHelper.tags.merge %w(center left right font)

Mime::Type.register "image/png", :png
Mime::Type.register "image/jpeg", :jpg
Mime::Type.register "text/smtp", :smtp

DEFAULT_TAG_CLOUD_SIZE = 30

