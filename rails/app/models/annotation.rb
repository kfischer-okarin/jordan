class Annotation < ApplicationRecord
  belongs_to :video

  delegate :youtube_id, to: :video

  serialize :payload, JSON

  alias :original_as_json :as_json

  def as_json
    super(only: %i[id video_timestamp payload])
  end

  def as_json_public
    original_as_json(only: %i[video_timestamp payload])
  end

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
