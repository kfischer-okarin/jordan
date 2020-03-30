# frozen_string_literal: true

FactoryBot.define do
  factory :annotation, class: 'Jordan::Entities::Annotation' do
    video_id { 'abc' }
    position { nil }
    payload { { type: :bible_verse, passage: 'Matthew 6:33' } }

    # TODO: Remove classname once FactoryBot fixes keyword args
    initialize_with { Jordan::Entities::Annotation.new(**attributes) }
  end
end
