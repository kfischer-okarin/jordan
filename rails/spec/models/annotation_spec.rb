require 'rails_helper'

RSpec.describe Annotation, type: :model do
  describe Annotation::Gateway do
    describe '.create' do
      subject { described_class.create(youtube_id: video.youtube_id, payload: payload) }

      let!(:video) { create(:video) }
      let(:payload) { { 'type' => 'text', 'text' => 'This is a text' } }

      it 'creates an unpublished annotation' do
        expect { subject }.to change { Annotation.count }.by(1)
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

    describe '.get' do
      subject { described_class.get(annotation.id) }

      let!(:annotation) { create(:annotation) }

      it 'returns the corresponding entity' do
        expect(subject).to be_a(Jordan::Entities::Annotation)
        expect(subject).to have_attributes(
          id: annotation.id,
          payload: annotation.payload,
          position: annotation.position,
          youtube_id: annotation.video.youtube_id
        )
      end
    end

    describe '.publish' do
      subject { described_class.publish(annotation_id: annotation.id, position: position) }

      let!(:annotation) { create(:annotation) }
      let(:position) { 20 }

      it 'updates the Annotation record' do
        expect { subject }.to change { annotation.reload.position }.from(nil).to(position)
      end
    end

    describe '.delete' do
      subject { described_class.delete(annotation.id) }

      let!(:annotation) { create(:annotation) }

      it 'removes the Annotation record' do
        expect { subject }.to change { Annotation.count }.by(-1)
        expect { Annotation.find(annotation.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
