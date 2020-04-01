class ApplicationController < ActionController::API
  rescue_from Jordan::Exceptions::InvalidParameters do |e|
    render json: { message: e.to_s }, status: :bad_request
  end

  rescue_from Jordan::Exceptions::Forbidden do |e|
    render json: { message: e.to_s }, status: :forbidden
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { message: e.to_s }, status: :not_found
  end

  def authorize!
    match = /^Bearer (?<token>.+)$/.match(request.headers['Authorization'])
    raise JWT::DecodeError unless match

    @user = User.from_token match[:token]
  rescue JWT::DecodeError
    render status: :unauthorized
  rescue JWT::ExpiredSignature
    render json: { message: e.to_s }, status: :unauthorized
  end
end
