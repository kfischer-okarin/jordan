FactoryBot.define do
  factory :video do
    sequence(:youtube_id) { |n| "abc#{n}" }
    sequence(:title) { |n| "Video ##{n}" }
    user
  end
end
