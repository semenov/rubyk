class AddCommentsCountToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :comments_count, :integer, :default => 0
    Post.reset_column_information
    Post.find(:all).each do |post|
      Post.update_counters post.id, :comments_count => post.comments.count
    end
    
  end

  def self.down
    remove_column :posts, :comments_count
  end
end
