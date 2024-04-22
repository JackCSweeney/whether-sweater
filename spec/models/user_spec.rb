require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    it { should validate_presence_of :email}
    it { should validate_uniqueness_of :email}
    it { should validate_presence_of :password }
    it { should validate_uniqueness_of :api_key}

    it 'should generate an api key when it is created' do
      user = User.create!({email: "test@email.com", password: "password", password_confirmation: "password"})
      expect(user).to be_a(User)
      expect(user.api_key).not_to eq(nil)
    end
  end
end