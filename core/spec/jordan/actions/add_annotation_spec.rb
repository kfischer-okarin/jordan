# frozen_string_literal: true

module Jordan
  module Actions
    RSpec.describe AddAnnotation do
      subject(:execute) { action.execute(user_id: user_id, youtube_id: youtube_id, payload: payload) }

      let(:action) { described_class.new(videos: videos, annotations: annotations) }

      let(:user_id) { :user_id }
      let(:youtube_id) { 'abc' }
      let(:payload) { :bible_passage }
      let(:video) { build(:video, owner: user_id) }

      let(:created_annotation) { :created_annotation }

      let(:videos) { spy('videos') }
      let(:annotations) { spy('annotations', create: created_annotation) }

      before do
        allow(videos).to receive(:get_by_youtube_id).with(youtube_id).and_return video
      end

      describe 'Errors' do
        it 'raises NotFound if video does not exist' do
          allow(videos).to receive(:get_by_youtube_id).and_raise Exceptions::NotFound

          expect { execute }.to raise_error Exceptions::NotFound
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

        expect(annotations).to have_received(:create).with(youtube_id: youtube_id, payload: payload)
      end

      it 'returns the created annotation' do
        expect(execute).to eq created_annotation
      end
    end
  end
end
