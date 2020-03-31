class Annotation < ApplicationRecord
  class Gateway
    def self.create(youtube_id:, payload:)
      Annotation.create(video: Video.find_by(youtube_id: youtube_id), payload: payload).as_entity
    end
  end

  belongs_to :video

  serialize :payload, JSON

  def as_entity
    Jordan::Entities::Annotation.new(id: id, youtube_id: video.youtube_id, position: position, payload: payload)
  end
end
