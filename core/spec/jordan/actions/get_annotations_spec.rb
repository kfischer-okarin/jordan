# frozen_string_literal: true

module Jordan
  module Actions
    RSpec.describe GetAnnotations do
      subject(:execute) { action.execute(user_id: user_id, youtube_id: youtube_id) }

      let(:action) { described_class.new(videos: videos, annotations: annotations) }

      let(:user_id) { :user_id }
      let(:youtube_id) { 'abc' }

      let(:retrieved_annotations) { :retrieved_annotations }

      let(:videos) { spy('videos') }
      let(:annotations) { spy('annotations') }

      before do
        allow(videos).to receive(:get_by_youtube_id).with(youtube_id).and_return video
      end

      context 'When the video is owned by the user' do
        let(:video) { build(:video, owner: user_id) }

        before do
          allow(annotations).to receive(:get_all_annotations).with(youtube_id: youtube_id).and_return retrieved_annotations
        end

        it 'retrieves all annotations' do
          execute

          expect(annotations).to have_received(:get_all_annotations).with(youtube_id: youtube_id)
        end

        it 'returns the returned annotation' do
          expect(execute).to eq retrieved_annotations
        end
      end

      context 'When the video is not owned by the user' do
        let(:video) { build(:video, owner: 'otheruser') }

        before do
          allow(annotations).to receive(:get_all_annotations).with(youtube_id: youtube_id, published_only: true)
            .and_return retrieved_annotations
        end

        it 'retrieves all published annotations' do
          execute

          expect(annotations).to have_received(:get_all_annotations).with(youtube_id: youtube_id, published_only: true)
        end

        it 'returns the returned annotation' do
          expect(execute).to eq retrieved_annotations
        end
      end
    end
  end
end
