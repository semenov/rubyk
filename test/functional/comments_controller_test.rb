require 'test_helper'

class CommentsControllerTest < ActionController::TestCase

  def test_create
    Comment.any_instance.expects(:save).returns(true)
    post :create, :comment => { }
    assert_response :redirect
  end

  def test_create_with_failure
    Comment.any_instance.expects(:save).returns(false)
    post :create, :comment => { }
    assert_template "new"
  end

  def test_destroy
    Comment.any_instance.expects(:destroy).returns(true)
    delete :destroy, :id => comments(:one).to_param
    assert_not_nil flash[:notice]    
    assert_response :redirect
  end

  def test_destroy_with_failure
    Comment.any_instance.expects(:destroy).returns(false)    
    delete :destroy, :id => comments(:one).to_param
    assert_not_nil flash[:error]
    assert_response :redirect
  end

  def test_edit
    get :edit, :id => comments(:one).to_param
    assert_response :success
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:comments)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_show
    get :show, :id => comments(:one).to_param
    assert_response :success
  end

  def test_update
    Comment.any_instance.expects(:save).returns(true)
    put :update, :id => comments(:one).to_param, :comment => { }
    assert_response :redirect
  end

  def test_update_with_failure
    Comment.any_instance.expects(:save).returns(false)
    put :update, :id => comments(:one).to_param, :comment => { }
    assert_template "edit"
  end

end