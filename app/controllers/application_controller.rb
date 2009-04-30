# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  layout "main"

  def login_required
    if session[:user_id]
      @user ||= User.find(session[:user_id])
      @access_token ||= OAuth::AccessToken.new(get_consumer, @user.oauth_token, @user.oauth_secret)
    else
      redirect_to :controller => 'session', :action => 'new'
    end
  end
  
  CONSUMER_KEY = "ruby.heroku.com"
  CONSUMER_SECRET = "gNBMNP7XzqazR+cENz0pVSz+"
  PATH_TO_PRIVATE_KEY = File.join(RAILS_ROOT, "config", "rsakey.pem")
 
  def get_consumer
    require 'oauth/consumer'
    require 'oauth/signature/rsa/sha1'
    consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, {
      :site => "https://www.google.com",
      :request_token_path => "/accounts/OAuthGetRequestToken",
      :access_token_path => "/accounts/OAuthGetAccessToken",
      :authorize_path=> "/accounts/OAuthAuthorizeToken",
      :signature_method => "RSA-SHA1",
      :private_key_file => PATH_TO_PRIVATE_KEY})
  end


  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
