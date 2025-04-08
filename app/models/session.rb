class Session < ApplicationRecord
  belongs_to :user
  
  validates :user, presence: true
  
  before_validation :generate_token, on: :create
  
  private
  
  def generate_token
    self.token = SecureRandom.hex(20)
  end
end
