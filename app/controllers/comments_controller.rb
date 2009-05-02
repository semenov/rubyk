class CommentsController < ApplicationController

  before_filter :find_comment
  before_filter :login_required, :except => [:index, :show]

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
    respond_to do |format|
      if @comment.save
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

  def find_comment
    @comment = Comment.find(params[:id]) if params[:id]
  end

end
