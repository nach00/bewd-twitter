# app/models/user.rb
class User < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_many :tweets, dependent: :destroy

  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 64 }
  validates :email, presence: true, uniqueness: true, length: { minimum: 5, maximum: 500 }
  validates :password, presence: true, length: { minimum: 8, maximum: 64 }

  has_secure_password
end

# app/models/session.rb
class Session < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true

  before_validation :generate_session_token

  private

  def generate_session_token
    self.token = SecureRandom.urlsafe_base64
  end
end

# app/models/tweet.rb
class Tweet < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :message, presence: true, length: { maximum: 140 }
end
