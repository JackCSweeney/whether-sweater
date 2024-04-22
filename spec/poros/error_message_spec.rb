require 'rails_helper'

RSpec.describe ErrorMessage do
  describe '#initialize' do
    it 'exists' do
      error_message = ErrorMessage.new("Error message", 404)

      expect(error_message).to be_a(ErrorMessage)
      expect(error_message.message).to eq("Error message")
      expect(error_message.status_code).to eq(404)
    end
  end
end