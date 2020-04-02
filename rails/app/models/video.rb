class Video < ApplicationRecord
  belongs_to :user
  has_many :annotations

  def as_entity
    Jordan::Entities::Video.new(owner: user_id)
  end
end
