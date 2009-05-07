require 'openid/extensions/ax'

class SessionController < ApplicationController
  skip_before_filter :login_required, :only => [:new, :create]
  
  def new
    oidreq = consumer.begin("https://www.google.com/accounts/o8/id")

    axreq = OpenID::AX::FetchRequest.new
    axreq.ns_alias = "ext1"
    single_attribute = OpenID::AX::AttrInfo.new("http://axschema.org/contact/email", "email", true)
    axreq.add(single_attribute)
    oidreq.add_extension(axreq)

    return_to = url_for :action => 'create', :only_path => false
    realm = root_url
    
    redirect_to oidreq.redirect_url(realm, return_to) 
  end
 
  def create
    current_url = url_for(:action => 'create', :only_path => false)
    parameters = params.reject{ |k, v| request.path_parameters[k] }
    oidresp = consumer.complete(parameters, current_url)
    
    if oidresp.status == OpenID::Consumer::SUCCESS
      open_id = oidresp.display_identifier
      user = User.find_or_create_by_open_id(open_id)
      ax_resp = OpenID::AX::FetchResponse.from_success_response(oidresp)
      if ax_resp
        email = ax_resp['http://axschema.org/contact/email'].first
        user = User.find_or_create_by_email(email)   
        user.open_id = open_id
        user.save(false)
      else
        user = User.find_or_create_by_open_id(open_id)      
      end
      session[:user_id] = user.id
    else
      flash[:notice] = "Авторизоваться через Google Account не удалось."    
    end
    
    redirect_to root_path
  end
 
  def destroy
    reset_session
    flash[:notice] = "Вы успешно вышли из системы"
    redirect_to root_path
  end
  
  private

  def consumer
    if @consumer.nil?
      store = ActiveRecordStore.new
      @consumer = OpenID::Consumer.new(session, store)
    end
    return @consumer
  end
  
  
end
