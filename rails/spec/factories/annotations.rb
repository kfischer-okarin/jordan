FactoryBot.define do
  factory :annotation do
    video
    position { nil }
    payload { { 'type' => 'bible_verse', 'passage': 'Matthe 6:33' } }
  end
end
