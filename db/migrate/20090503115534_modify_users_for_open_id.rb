class ModifyUsersForOpenId < ActiveRecord::Migration
  def self.up
    remove_column :users, :oauth_token
    remove_column :users, :oauth_secret
    add_column :users, :open_id, :string
  end

  def self.down
    add_column :users, :oauth_token, :string
    add_column :users, :oauth_secret, :string
    remove_column :users, :open_id
  end
end
