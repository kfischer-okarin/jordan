class Annotation < ApplicationRecord
  class Gateway
    def self.create(youtube_id:, payload:)
      Annotation.create(video: Video.find_by(youtube_id: youtube_id), payload: payload).as_entity
    end

    def self.get(id)
      Annotation.find(id).as_entity
    end

    def self.publish(annotation_id:, position:)
      Annotation.find(annotation_id).update(position: position)
    end
  end

  belongs_to :video

  serialize :payload, JSON

  def as_entity
    Jordan::Entities::Annotation.new(id: id, youtube_id: video.youtube_id, position: position, payload: payload)
  end
end
