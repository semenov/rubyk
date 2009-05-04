class RemoveCommentsWithoutPosts < ActiveRecord::Migration
  def self.up
    Comment.all.each do |c|
      c.destroy if c.post.nil?
    end
  end

  def self.down
  end
end
