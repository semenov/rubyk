class SessionController < ApplicationController
  skip_before_filter :login_required, :only => [:new, :create]
 
  def new
    consumer = get_consumer
    request_token = consumer.get_request_token( {}, {:scope => "https://www.google.com/m8/feeds/"})
    session[:oauth_secret] = request_token.secret
    next_url = url_for :action => 'create', :protocol => 'https'
    redirect_to request_token.authorize_url + "&oauth_callback=#{next_url}"
  end
 
  def create
    request_token = OAuth::RequestToken.new(get_consumer, params[:oauth_token], session[:oauth_secret])
    access_token = request_token.get_access_token
    xml = XmlSimple.xml_in(access_token.get("https://www.google.com/m8/feeds/contacts/default/full/").body)
    email = xml["author"].first["email"].first
    user = User.find_or_create_by_email(email)
    user.name = xml["author"].first["name"].first
    user.oauth_token  =  access_token.token
    user.oauth_secret =  access_token.secret
    user.save
    session[:user_id] = user.id
    redirect_to :controller => 'posts'
  end
 
  def delete
    reset_session
    flash[:notice] = "Вы успешно вышли из системы"
    redirect_to :controller => 'posts'
  end
end
