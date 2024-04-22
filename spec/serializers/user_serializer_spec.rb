require 'rails_helper'

RSpec.describe UserSerializer do
  before(:each) do
    @user = User.create!({email: "test@email.com", password: "password", password_confirmation: "password"})
  end

  describe '.class methods' do
    describe '.serialize' do
      it 'returns the data in a proper structure to be rendered as JSON' do
        result = UserSerializer.serialize(@user)

        expect(result).to have_key(:data)
        expect(result[:data]).to be_a(Hash)

        data = result[:data]

        expect(data).to have_key(:type)
        expect(data[:type]).to eq("users")
        expect(data).to have_key(:id)
        expect(data[:id]).to eq(@user.id)
        expect(data).to have_key(:attributes)
        expect(data[:attributes]).to be_a(Hash)

        attributes = data[:attributes]

        expect(attributes).to have_key(:email)
        expect(attributes[:email]).to eq(@user.email)
        expect(attributes).to have_key(:api_key)
        expect(attributes[:api_key]).to eq(@user.api_key)
      end
    end
  end
end