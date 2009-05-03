# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  layout "main"

  helper_method :current_user, :logged_in?, :user_can_edit?
  
  def login_required
    if !current_user
      #redirect_to auth_info_path
      render :template => "pages/auth_info"
    end
  end
  
  def current_user
    return nil if !session[:user_id]
    @current_user = User.find(session[:user_id]) if @current_user.nil?
    return @current_user
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

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
