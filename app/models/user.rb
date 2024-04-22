class User < ApplicationRecord
  before_create :generate_key

  validates :email, presence: true, uniqueness: true
  validates :api_key, uniqueness: true
  validates :password, presence: true
  has_secure_password

  private
  def generate_key
    self.api_key = SecureRandom::base58(24)
  end
end