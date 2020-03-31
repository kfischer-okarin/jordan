module Jordan
  module RequestSpecHelpers
    def headers_for(user)
      { Authorization: "Bearer #{user.token}" }
    end
  end
end

RSpec.configure do |config|
  config.include Jordan::RequestSpecHelpers, type: :request
end
