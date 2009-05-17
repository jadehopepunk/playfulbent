# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger        = SyslogLogger.new


# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors if you bad email addresses should just be ignored
# config.action_mailer.raise_delivery_errors = false

config.action_mailer.delivery_method = :smtp

ActionController::UrlWriter.default_url_options[:host] = "www.playfulbent.com"
ActionController::Base.session_options[:session_domain] = 'playfulbent.com'

# PAYPAL INTEGRATION
config.app_config.paypal_url = 'https://www.paypal.com/cgi-bin/webscr'
config.app_config.paypal_email = 'paypal@bentproductions.biz'

config.app_config.google_maps_key = 'ABQIAAAAeBPm_-KwgwjbZtYJENq_NxSXaGM-1g05mGX6VFl9XFniu-YNshSTS7GIAFDjvGzJ53sScZO7htf4xw'

config.action_controller.asset_host = "http://assets%d.playfulbent.com"

# FLICKR INTEGRATION
config.app_config.flickr_api_key = '602d84f6664de4a28c0c17d4402ddc79'
config.app_config.flickr_shared_secret = '8efd3392a6cb946d'
