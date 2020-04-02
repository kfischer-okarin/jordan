class Video < ApplicationRecord
  belongs_to :user, inverse_of: :videos
  has_many :annotations, inverse_of: :video, dependent: :destroy

  enum status: [:upcoming, :streaming, :streamed]
end
