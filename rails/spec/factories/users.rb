FactoryBot.define do
  factory :user do
    sequence(:user_id) { |n| "user#{n}" }
    name { "Bob" }
    email { "bob@example.com" }

    factory :google_user do
      provider { 'google' }
    end
  end
end
