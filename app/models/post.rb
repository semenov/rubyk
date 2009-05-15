class Post < ActiveRecord::Base
  validates_presence_of :content
  named_scope :published, :conditions => {:published => true} , :order => "created_at DESC"  
  belongs_to :author, :class_name => "User", :foreign_key => "user_id"
  has_many :comments, :order => 'created_at', :dependent => :destroy
  acts_as_taggable_on :tags
  
  def can_edit?(user)
    return false if !user
    return author.id == user.id || user.admin?
  end

end
