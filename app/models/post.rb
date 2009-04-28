class Post < ActiveRecord::Base
  validates_presence_of :content
  named_scope :published, :conditions => {:published => true} , :order => "created_at DESC"  
end
