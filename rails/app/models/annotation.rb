class Annotation < ApplicationRecord
  class Gateway
    def self.create(youtube_id:, payload:)
      video = Video.find_by(youtube_id: youtube_id)
      next_position = Annotation.where(video: video).order(:position).last&.position || 1
      Annotation.create(video: video, payload: payload, position: next_position).as_entity
    end

    def self.get(id)
      Annotation.find(id).as_entity
    end

    def self.get_all_annotations(youtube_id:, published_only: false)
      result = Annotation.joins(:video).where(videos: { youtube_id: youtube_id })
      if published_only
        result = result.where.not(video_timestamp: nil).order(:video_timestamp)
      else
        result = result.order(:position)
      end
      result.map(&:as_entity)
    end

    def self.publish(annotation_id:, video_timestamp:)
      Annotation.find(annotation_id).tap { |published|
        published.update(video_timestamp: video_timestamp)
      }.as_entity
    end

    def self.delete(annotation_id)
      Annotation.find(annotation_id).destroy
    end
  end

  belongs_to :video

  serialize :payload, JSON

  def as_entity
    Jordan::Entities::Annotation.new(
      id: id,
      youtube_id: video.youtube_id,
      video_timestamp: video_timestamp,
      position: position,
      payload: payload
    )
  end
end
