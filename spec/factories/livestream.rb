# frozen_string_literal: true

FactoryBot.define do
  factory :livestream, class: 'Jordan::Entities::Livestream' do
    start { Time.now - 30 * 60 }

    # TODO: Remove classname once FactoryBot fixes keyword args
    initialize_with { Jordan::Entities::Livestream.new(**attributes) }
  end
end
