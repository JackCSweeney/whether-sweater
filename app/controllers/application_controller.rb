class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_record_response

  def invalid_record_response(exception)
    render json: ErrorMessageSerializer.serialize(ErrorMessage.new(exception.message, 400)), status: 400
  end
end
