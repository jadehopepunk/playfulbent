config.cache_classes     = true
config.whiny_nils        = true
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

config.action_mailer.delivery_method = :restricted
config.app_config.restricted_address = 'craig@craigambrose.com'

ActionController::UrlWriter.default_url_options[:host] = "www.railsmanager.com"
ActionController::UrlWriter.default_url_options[:only_path] = false
ActionController::Base.session_options[:session_domain] = 'railsmanager.com'

# GOOGLE MAPS
config.app_config.google_maps_key = 'ABQIAAAAeBPm_-KwgwjbZtYJENq_NxS7NkuUqTQXmbFLDL-0MDIzYkOyshTclNb6arr_UzuIQgSG2LGYi0c7JA'

config.action_controller.asset_host = "http://www.railsmanager.com"