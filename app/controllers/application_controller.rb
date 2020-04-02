class ApplicationController < ActionController::API
  class InvalidParameters < StandardError; end
  class Forbidden < StandardError; end
  class Unauthorized < StandardError; end
  class InvalidOperation < StandardError; end

  rescue_from InvalidParameters do |e|
    render json: { message: e.to_s }, status: :bad_request
  end

  rescue_from Unauthorized do |e|
    render json: { message: e.to_s }, status: :unauthorized
  end

  rescue_from Forbidden do |e|
    render json: { message: e.to_s }, status: :forbidden
  end

  rescue_from InvalidOperation do |e|
    render json: { message: e.to_s }, status: :unprocessable_entity
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { message: e.to_s }, status: :not_found
  end

  def authorize!
    match = /^Bearer (?<token>.+)$/.match(request.headers['Authorization'])
    raise JWT::DecodeError unless match

    @user = User.from_token match[:token]
  rescue JWT::DecodeError, JWT::ExpiredSignature => e
    raise Unauthorized.new(e)
  end

  def authorize
    authorize!
  rescue Unauthorized
  end
end
