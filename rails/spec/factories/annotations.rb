FactoryBot.define do
  factory :annotation do
    video
    sequence(:position)
    video_timestamp { nil }
    payload { { 'type' => 'bible_verse', 'passage': 'Matthe 6:33' } }
  end
end
