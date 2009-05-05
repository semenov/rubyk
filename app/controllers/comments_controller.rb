Mime::Type.register "image/png", :png

class CommentsController < ApplicationController

  before_filter :find_object
  before_filter :login_required, :only => [:new, :create, :edit, :update, :destroy]

  def index
    @comments = Comment.paginate(:order => "created_at DESC", :page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html
      format.xml  { render :xml => @comments }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml  { render :xml => @comment }
    end
  end
  
  def count
    post = Post.find(params[:post_id])
    comments_count = post.comments_count
    
    respond_to do |format|
      format.html { render :text => post.comments_count }
      format.png do 
        cached_file = Rails.root.join("tmp/cache/comments_count_#{comments_count}.png")
        
        if !File.exists? cached_file
          icon_path = Rails.root.join("public/images/comment.png")
          icon = Magick::Image.read(icon_path).first
          canvas = Magick::Image.new(80, 32)
          canvas.composite!(icon, 0, 0, Magick::OverCompositeOp)

          text = Magick::Draw.new
          text.pointsize = 22.0
          
          if comments_count == 0
            text.fill = 'grey'
          else
            text.fill = 'black'
          end
          
          text.gravity = Magick::WestGravity

          # Tweak the font to draw slightly up and left from the center
          text.annotate(canvas, 0, 0, 40, 0, comments_count.to_s)
          
          cached_file = Rails.root.join("tmp/cache/comments_count_#{comments_count}.png")
          canvas.transparent("white").write cached_file
        end
   
        send_file cached_file, :disposition => "inline", :type => "image/png" 
      end
    end  

  end

  def new
    @comment = Comment.new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @comment }
    end
  end

  def create
    @comment = Comment.new(params[:comment])
    @comment.author = current_user
    @comment.post = Post.find params[:post_id]
    
    if params.has_key?(:user)
      current_user.name = params[:user][:name] if !params[:user][:name].empty?
      current_user.save
    end
        
    respond_to do |format|
      if @comment.valid? && current_user.valid? 
        @comment.save
        flash[:notice] = 'Комментарий добавлен.'
        format.html { redirect_to @comment.post }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    return redirect_to root_path if !user_can_edit? @comment
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Комментарий сохранен.'
        format.html { redirect_to @comment.post }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    return redirect_to root_path if !user_can_edit? @comment
    respond_to do |format|
      if @comment.destroy
        flash[:notice] = 'Комментарий удален.'        
        format.html { redirect_to @comment.post }
        format.xml  { head :ok }
      else
        flash[:error] = 'Comment could not be destroyed.'
        format.html { redirect_to @comment }
        format.xml  { head :unprocessable_entity }
      end
    end
  end

  private

  def find_object
    @comment = Comment.find(params[:id]) if params[:id]
  end

end
