class ApplicationController < ActionController::API
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
