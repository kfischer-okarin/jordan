# frozen_string_literal: true

module Jordan
  module Actions
    RSpec.describe FinalizeLivestream do
      subject(:execute) { action.execute(user_id: user_id, video_id: video_id) }

      let(:action) { described_class.new(videos: videos) }

      let(:user_id) { :user }
      let(:video_id) { :video_id }

      let(:video) { build(:livestream, owner: user_id) }
      let(:finalized_video) { :finalized_video }

      let(:videos) { spy('videos', get: video, finalize: finalized_video) }

      describe 'Errors' do
        it 'raises NotFound if video does not exist' do
          allow(videos).to receive(:get).and_raise Exceptions::NotFound

          expect { execute }.to raise_error Exceptions::NotFound
        end

        context 'when the video is not owned by the user' do
          let(:video) { build(:livestream, owner: 'other_user') }

          it 'raises Forbidden' do
            expect { subject }.to raise_error Exceptions::Forbidden
          end
        end

        context 'when the video is not a livestream' do
          let(:video) { build(:video, owner: user_id) }

          it 'raises Unprocessable' do
            expect { subject }.to raise_error Exceptions::Unprocessable
          end
        end
      end

      it 'finalizes the livestream' do
        execute

        expect(videos).to have_received(:finalize).with(video_id)
      end

      it 'returns the finalized video' do
        expect(execute).to eq finalized_video
      end
    end
  end
end
