require 'rails_helper'

RSpec.describe "User Can Log In to Start Session" do
  before(:each) do
    @user = User.create!({email: "test@email.com", password: "password", password_confirmation: "password"})
    @headers = {"CONTENT_TYPE" => "application/json"}
    @body = {email: "test@email.com", password: "password"}
    @bad_email = {email: "bad@email.com", password: "password"}
    @bad_password = {email: "test@email.com", password: "wrong password"}
  end

  describe '#happy path' do
    it 'can log in and be returned the correct response when logged in with correct information' do
      post "/api/v0/sessions", headers: @headers, params: JSON.generate(@body)

      expect(response).to be_successful
      expect(response.status).to eq(200)

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
      expect(attributes).not_to have_key(:password)
      expect(attributes).not_to have_key(:password_digest)
    end
  end

  describe '#sad path' do
    it 'will return the correct error message if the email is incorrect' do
      post "/api/v0/sessions", headers: @headers, params: JSON.generate(@bad_email)

      expect(response).not_to be_successful
      expect(response.status).to eq(401)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result).to have_key(:errors)
      expect(result[:errors]).to be_a(Hash)
      expect(result[:errors]).to have_key(:message)
      expect(result[:errors][:message]).to eq("Error: Email/Password incorrect")
    end

    it 'will return the correct error message if the password is incorrect' do
      post "/api/v0/sessions", headers: @headers, params: JSON.generate(@bad_password)

      expect(response).not_to be_successful
      expect(response.status).to eq(401)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result).to have_key(:errors)
      expect(result[:errors]).to be_a(Hash)
      expect(result[:errors]).to have_key(:message)
      expect(result[:errors][:message]).to eq("Error: Email/Password incorrect")
    end
  end
end