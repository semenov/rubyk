class PostsController < ApplicationController

  before_filter :login_required, :except => [:index, :show]
  
  # GET /posts
  # GET /posts.xml
  def index
    @posts = Post.published.paginate :page => params[:page], :per_page => 10

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id])
    @comment = Comment.new

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # POST /posts
  # POST /posts.xml
  def create 
    @post = Post.new(params[:post])
    @post.published = true
    @post.author = current_user

    respond_to do |format|
      if @post.save
        flash[:notice] = 'Запись успешно создана.'
        format.html { redirect_to(@post) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  def edit
    @post = Post.find(params[:id])
    
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @post }
    end    
  end
  

  def update
    @post = Post.find(params[:id])
    return redirect_to root_path if !user_can_edit? @post
    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Запись успешно сохранена.'
        format.html { redirect_to(@post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end  
  

  def destroy
    @post = Post.find(params[:id])
    return redirect_to root_path if !user_can_edit? @post
    @post.destroy
    
    flash[:notice] = 'Запись успешно удалена.'
    
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
  

end
