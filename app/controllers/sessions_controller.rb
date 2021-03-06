class SessionsController < ApplicationController
  def create
    validator = GoogleIDToken::Validator.new
    payload = validator.check(idtoken, Rails.application.credentials.google_client_id)

    token = nil
    User.transaction do
      user = User.find_or_create_by(provider: 'google', user_id: payload['sub'])
      user.update(name: payload['name'], email: payload['email'])
      token = user.sign_in
    end

    render json: { api_token: token }
  rescue GoogleIDToken::ValidationError => e
    render json: { message: e.to_s }, status: :unauthorized
  end

  private

  def idtoken
    params.require(:idtoken)
  end
end
