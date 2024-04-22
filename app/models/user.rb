class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :api_key, presence: true, uniqueness: true
  validates :password, presence: true
  has_secure_password

  before_create :generate_key

  private
  def generate_key
    self.api_key = SecureRandom::base58(24)
  end
end