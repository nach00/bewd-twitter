class User < ApplicationRecord
  has_secure_password
  
  has_many :sessions, dependent: :destroy
  has_many :tweets, dependent: :destroy
  
  validates :email, presence: true, uniqueness: true, length: { minimum: 5, maximum: 500 }
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 64 }
  validates :password, presence: true, length: { minimum: 8, maximum: 64 }, if: :password_digest_changed?
end
