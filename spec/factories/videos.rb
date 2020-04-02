FactoryBot.define do
  factory :video do
    sequence(:youtube_id) { |n| "abc#{n}" }
    user
  end
end
