class Comment < ActiveRecord::Base
  validates_presence_of :content
  belongs_to :post, :counter_cache => true
  belongs_to :author, :class_name => "User", :foreign_key => "user_id"
end
