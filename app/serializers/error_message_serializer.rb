class ErrorMessageSerializer
  include JSONAPI::Serializer
  attributes :message, :status_code
end
