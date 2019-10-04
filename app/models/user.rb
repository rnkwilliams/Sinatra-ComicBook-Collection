class User < ActiveRecord::Base
  has_secure_password
  has_many :comic_books
  
end