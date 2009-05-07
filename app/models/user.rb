class User < ActiveRecord::Base
  validates_presence_of :email, :name
  #validates_uniqueness_of :email
  
  def username
    email.split('@').first
  end
end
