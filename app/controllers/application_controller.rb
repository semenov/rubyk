# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  layout "main"

  helper_method :current_user, :logged_in?, :user_can_edit?
  
  def login_required
    if !current_user
      redirect_to auth_info_path
    end
  end
  
  def current_user
      session[:user]
  end
  
  def logged_in?
    !current_user.nil?
  end
   
  def user_can_edit?(object)
    if logged_in?
      object.author.id == current_user.id || current_user.admin?
    else
      false
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
