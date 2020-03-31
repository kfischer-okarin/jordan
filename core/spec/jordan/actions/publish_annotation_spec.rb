# frozen_string_literal: true

module Jordan
  module Actions
    RSpec.describe PublishAnnotation do
      subject(:execute) { action.execute(user_id: user_id, annotation_id: annotation_id, position: position) }

      let(:action) { described_class.new(videos: videos, annotations: annotations, viewers: viewers) }

      let(:annotation_id) { :annotation_id }
      let(:youtube_id) { 'abc' }
      let(:position) { 10 }
      let(:user_id) { :user_id }

      let(:video) { build(:video, owner: user_id) }
      let(:annotation) { build(:annotation, youtube_id: youtube_id) }

      let(:videos) { spy('videos') }
      let(:annotations) { spy('annotations', get: annotation, publish: annotation) }
      let(:viewers) { spy('viewers') }

      before do
        allow(videos).to receive(:get_by_youtube_id).with(youtube_id).and_return(video)
      end

      describe 'Errors' do
        it 'raises NotFound if annotation does not exist' do
          allow(annotations).to receive(:get).and_raise Exceptions::NotFound

          expect { execute }.to raise_error Exceptions::NotFound
        end

        context 'when specifying a negative position' do
          let(:position) { -1 }

          it 'raises InvalidParameters' do
            expect { subject }.to raise_error Exceptions::InvalidParameters
          end
        end

        context 'When the video is not owned by the user' do
          let(:video) { build(:video, owner: 'someone else') }

          it 'raises Forbidden' do
            expect { subject }.to raise_error Exceptions::Forbidden
          end
        end
      end

      it 'publishes the Annotation' do
        execute

        expect(annotations).to have_received(:publish).with(annotation_id: annotation_id, position: position)
      end

      it 'notifies the viewers' do
        execute

        expect(viewers).to have_received(:notify).with(annotation)
      end
    end
  end
end
