class User < ApplicationRecord
  def sign_in
    payload = { exp: 24.hours.from_now.to_i, user_id: id }
    JWT.encode(payload, Rails.application.secrets.secret_key_base).tap { |token|
      update(token: token)
    }
  end
end
