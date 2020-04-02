class User < ApplicationRecord
  has_many :videos, inverse_of: :user

  def sign_in
    payload = { exp: 24.hours.from_now.to_i, user_id: id }
    JWT.encode(payload, Rails.application.credentials.secret_key_base).tap { |token|
      update(token: token)
    }
  end

  def self.from_token(token)
    payload, _ = JWT.decode(token, Rails.application.credentials.secret_key_base)
    find(payload['user_id'])
  end
end
