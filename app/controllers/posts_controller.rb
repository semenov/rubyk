class PostsController < ApplicationController

  before_filter :find_object
  before_filter :login_required, :only => [:new, :create, :edit, :update, :destroy]
  
  def index
    @posts = Post.published.paginate :page => params[:page], :per_page => 10
    @tags = Post.tag_counts

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  def index_php_redirect
    redirect_to root_path
  end
  
  def with_tag
    @posts = Post.published.
                  tagged_with(params[:tag], :on => :tags).
                  paginate(:page => params[:page], :per_page => 10)
    @tags = Post.tag_counts
    @current_tag = params[:tag]

    respond_to do |format|
      format.html { render :action => "index" }
      format.xml  { render :xml => @posts }
    end
  end  

  def show
    @comment = Comment.new

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  def new
    @post = Post.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  def create 
    @post = Post.new(params[:post])
    @post.published = true
    @post.author = current_user
    
    if params.has_key?(:user)
      current_user.name = params[:user][:name] if !params[:user][:name].empty?
      current_user.save
    end
    
    respond_to do |format|
      if @post.valid? && current_user.valid?
        @post.save
        flash[:notice] = 'Заметка успешно создана.'
        format.html { redirect_to(@post) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  def edit   
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @post }
    end    
  end
  

  def update
    return redirect_to root_path if !user_can_edit? @post
    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Заметка успешно сохранена.'
        format.html { redirect_to(@post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end  
  

  def destroy
    return redirect_to root_path if !user_can_edit? @post
    @post.destroy
    
    flash[:notice] = 'Заметка успешно удалена.'
    
    respond_to do |format|
      format.html { redirect_to(root_path) }
      format.xml  { head :ok }
    end
  end    
  
  def feed
    @posts = Post.published(:limit => 10)
    response.headers['Content-Type'] = 'application/rss+xml'
    render :action => "feed", :layout => false
  end
  
  private

  def find_object
    @post = Post.find(params[:id]) if params[:id]
  end  

end
