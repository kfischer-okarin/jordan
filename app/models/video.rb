class Video < ApplicationRecord
  belongs_to :user, inverse_of: :videos
  has_many :annotations, inverse_of: :video, dependent: :destroy

  enum status: [:upcoming, :streaming, :streamed]

  def json
    as_json(only: %i[youtube_id status])
  end

  def public_json
    as_json(only: %i[youtube_id status], include: { user: { only: :name } })
  end
end
