require 'rails_helper'

RSpec.describe 'Create New User and Get API Key' do
  before(:each) do
    @headers = {"CONTENT_TYPE" => "application/json"}
    @body = {
      email: "test@email.com",
      password: "password",
      password_confirmation: "password"
    }
  end

  describe '#happy path' do
    it 'can make a post request with new user info in the body of request and receive back confirmation of user being added as well as an API key for the account' do
      post "/api/v0/users", headers: @headers, params: JSON.generate(@body)

      expect(response).to be_successful
      expect(response.status).to eq(201)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result).to have_key(:data)
      expect(result[:data]).to be_a(Hash)

      data = result[:data]

      expect(data).to have_key(:type)
      expect(data[:type]).to eq("users")
      expect(data).to have_key(:id)
      expect(data[:id]).to be_a(Integer)
      expect(data).to have_key(:attributes)
      expect(data[:attributes]).to be_a(Hash)

      attributes = data[:attributes]

      expect(attributes).to have_key(:email)
      expect(attributes[:email]).to eq(@body[:email])
      expect(attributes).to have_key(:api_key)
      expect(attributes[:api_key]).to be_a(String)
    end
  end

  describe '#sad path' do
    it 'returns the appropriate error message for invalid/missing credentials' do
      post "/api/v0/users", headers: @headers, params: JSON.generate({email: "", password: "password", password_confirmation: "password"})

      expect(response).not_to be_successful
      expect(response.status).to eq(400)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result).to have_key(:errors)
      expect(result[:errors]).to be_a(Hash)
      expect(result[:errors]).to have_key(:message)
      expect(result[:errors][:message]).to eq("Validation failed: Email can't be blank")
    end

    it 'returns the appropriate error message for non-matching passwords' do
      post "/api/v0/users", headers: @headers, params: JSON.generate({email: "test@email.com", password: "password", password_confirmation: "pasrd"})

      expect(response).not_to be_successful
      expect(response.status).to eq(400)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result).to have_key(:errors)
      expect(result[:errors]).to be_a(Hash)
      expect(result[:errors]).to have_key(:message)
      expect(result[:errors][:message]).to eq("Validation failed: Password confirmation doesn't match Password")
    end

    it 'returns the appropriate error message for non-unique email' do
      post "/api/v0/users", headers: @headers, params: JSON.generate({email: "test@email.com", password: "password", password_confirmation: "password"})

      post "/api/v0/users", headers: @headers, params: JSON.generate({email: "test@email.com", password: "password", password_confirmation: "password"})

      expect(response).not_to be_successful
      expect(response.status).to eq(400)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result).to have_key(:errors)
      expect(result[:errors]).to be_a(Hash)
      expect(result[:errors]).to have_key(:message)
      expect(result[:errors][:message]).to eq("Validation failed: Email has already been taken")
    end
  end
end