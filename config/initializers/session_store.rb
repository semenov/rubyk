# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_nanoblog_session',
  :secret      => '9d252599e7f6db59a26c8864e615a76ecfdc051364248d78c58246f7b6b1ed3e90dc1a5af844d7ed2b937d44395caa2def16806c94488143726220681816dfa3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
