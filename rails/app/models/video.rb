class Video < ApplicationRecord
  belongs_to :user

  class << self
    def register(owner:, youtube_id:)
      create(user_id: owner, youtube_id: youtube_id)
    end

    def get_by_youtube_id(youtube_id)
      find_by(youtube_id: youtube_id).as_entity
    end
  end

  def as_entity
    Jordan::Entities::Video.new(owner: user_id)
  end
end
