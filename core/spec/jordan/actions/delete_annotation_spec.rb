# frozen_string_literal: true

module Jordan
  module Actions
    RSpec.describe DeleteAnnotation do
      subject(:execute) { action.execute(user_id: user_id, annotation_id: annotation_id) }

      let(:action) { described_class.new(videos: videos, annotations: annotations) }

      let(:user_id) { :user_id }
      let(:annotation_id) { 1 }
      let(:youtube_id) { 'abc' }
      let(:video) { build(:video, owner: user_id) }
      let(:annotation) { build(:annotation, youtube_id: youtube_id) }

      let(:videos) { spy('videos') }
      let(:annotations) { spy('annotations') }

      before do
        allow(videos).to receive(:get_by_youtube_id).with(youtube_id).and_return video
        allow(annotations).to receive(:get).with(annotation_id).and_return annotation
      end

      describe 'Errors' do
        it 'raises NotFound if annotation does not exist' do
          allow(annotations).to receive(:get).and_raise Exceptions::NotFound

          expect { execute }.to raise_error Exceptions::NotFound
        end

        context 'when the video is not owned by the user' do
          let(:video) { build(:video, owner: 'other_user') }

          it 'raises Forbidden' do
            expect { subject }.to raise_error Exceptions::Forbidden
          end
        end
      end

      it 'removes the Annotation' do
        execute

        expect(annotations).to have_received(:delete).with(annotation_id)
      end
    end
  end
end
