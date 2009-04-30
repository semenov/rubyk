class User < ActiveRecord::Base
  validates_presence_of :email, :oauth_token, :oauth_secret
  validates_uniqueness_of :email
end
