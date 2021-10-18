# frozen_string_literal: true

module Errors
  # Custom error class for rescuing from all Nomics errors
  class APIExceptionError < StandardError; end

  BadRequestError = Class.new(APIExceptionError)
  UnauthorizedError = Class.new(APIExceptionError)
  ForbiddenError = Class.new(APIExceptionError)
  ApiRequestsQuotaReachedError = Class.new(APIExceptionError)
  NotFoundError = Class.new(APIExceptionError)
  UnprocessableEntityError = Class.new(APIExceptionError)
  ApiError = Class.new(APIExceptionError)

  # @param status [Integer] status code returned by Nomics API
  # @return [APIExceptionError]
  def error_class(status)
    case status
    when 400
      BadRequestError
    when 401
      UnauthorizedError
    when 403
      ForbiddenError
    when 404
      NotFoundError
    when 429
      UnprocessableEntityError
    else
      ApiError
    end
  end
end
