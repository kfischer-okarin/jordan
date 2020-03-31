require 'rails_helper'

RSpec.describe Annotation, type: :model do
  describe Annotation::Gateway do
    describe '.create' do
      subject { described_class.create(youtube_id: video.youtube_id, payload: payload) }

      let(:video) { create(:video) }
      let(:payload) { { 'type' => 'text', 'text' => 'This is a text' } }

      it 'creates an unpublished annotation' do
        expect { subject }.to change { Video.count }.by(1)
        expect(Annotation.first).to have_attributes(video: video, payload: payload, position: nil)
      end

      it 'returns the corresponding entity' do
        expect(subject).to be_a(Jordan::Entities::Annotation)
        expect(subject).to have_attributes(
          id: an_instance_of(Integer),
          payload: payload,
          position: nil,
          youtube_id: video.youtube_id
        )
      end
    end
  end
end
