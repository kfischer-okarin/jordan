# frozen_string_literal: true

module Jordan
  module Actions
    RSpec.describe AddBiblePassage do
      subject(:execute) { action.execute(user_id: user_id, video_id: video_id, position: position, passage: passage) }

      let(:action) { described_class.new(videos: videos, annotations: annotations, viewers: viewers) }

      let(:user_id) { :user_id }
      let(:video_id) { :video }
      let(:position) { 10 }
      let(:passage) { :bible_passage }

      let(:video) { build(:video, owner: user_id) }
      let(:created_annotation) { :created_annotation }

      let(:videos) { spy('videos', get: video) }
      let(:annotations) { spy('annotations', create: created_annotation) }
      let(:viewers) { spy('viewers') }

      describe 'Errors' do
        it 'raises NotFound if video does not exist' do
          allow(videos).to receive(:get).and_raise Exceptions::NotFound

          expect { execute }.to raise_error Exceptions::NotFound
        end

        context 'when specifying a negative position' do
          let(:position) { -1 }

          it 'raises InvalidParameters' do
            expect { subject }.to raise_error Exceptions::InvalidParameters
          end
        end

        context 'when specifying a position outside of the video' do
          let(:position) { video.duration + 1 }

          it 'raises InvalidParameters' do
            expect { subject }.to raise_error Exceptions::Unprocessable
          end
        end

        context 'when the video is not owned by the user' do
          let(:video) { build(:video, owner: 'other_user') }

          it 'raises Forbidden' do
            expect { subject }.to raise_error Exceptions::Forbidden
          end
        end
      end

      it 'creates an Annotation' do
        execute

        expect(annotations).to have_received(:create).with(video_id: video_id, position: position, type: :bible_verse, passage: passage)
      end

      it 'notifies the viewers' do
        execute

        expect(viewers).to have_received(:notify).with(created_annotation)
      end

      it 'returns the created annotation' do
        expect(execute).to eq created_annotation
      end
    end
  end
end
