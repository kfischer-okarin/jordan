class Video < ApplicationRecord
  belongs_to :user

  class << self
    def register(owner:, youtube_id:)
      create(user_id: owner, youtube_id: youtube_id)
    end
  end
end
