class ErrorMessageSerializer
  def self.serialize(error_message)
    {
      errors:
        {message: error_message.message}
    }
  end
end
