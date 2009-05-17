config.cache_classes     = true
config.whiny_nils        = true
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

config.action_mailer.delivery_method = :restricted

ActionController::UrlWriter.default_url_options[:host] = "www.railsmanager.com"
ActionController::UrlWriter.default_url_options[:only_path] = false
ActionController::Base.session_options[:session_domain] = 'railsmanager.com'

config.action_controller.asset_host = "http://www.railsmanager.com"