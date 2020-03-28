# frozen_string_literal: true

FactoryBot.define do
  factory :video, class: 'Jordan::Entities::Video' do
    duration { 60 }

    # TODO: Remove classname once FactoryBot fixes keyword args
    initialize_with { Jordan::Entities::Video.new(**attributes) }
  end
end
