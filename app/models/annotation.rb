class Annotation < ApplicationRecord
  belongs_to :video, inverse_of: :annotations

  delegate :youtube_id, to: :video

  before_create :initialize_position

  serialize :payload, JSON

  alias :original_as_json :as_json

  def as_json
    super(only: %i[id video_timestamp payload])
  end

  def as_json_public
    original_as_json(only: %i[video_timestamp payload])
  end

  private

  def initialize_position
    last_position = video.annotations.order(:position).last&.position || 0
    self.position = last_position + 1
  end
end
