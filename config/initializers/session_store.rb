# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_playfulbent_session',
  :secret      => 'ccd09a8eb38ef04ccbc69a3ddde348819ef589f2a9706337c6a1296f43a4bd9d0c8ed7a171277322e2987bc36723e355dfc509f7ce930fea9161648be57ab39a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
