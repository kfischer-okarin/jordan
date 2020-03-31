class Video < ApplicationRecord
  class Gateway
    class << self
      def register(owner:, youtube_id:)
        Video.create(user_id: owner, youtube_id: youtube_id)
      end

      def get_by_youtube_id(youtube_id)
        Video.find_by(youtube_id: youtube_id).as_entity
      end
    end
  end

  belongs_to :user

  def as_entity
    Jordan::Entities::Video.new(owner: user_id)
  end
end
