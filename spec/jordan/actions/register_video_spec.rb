# frozen_string_literal: true

module Jordan
  module Actions
    RSpec.describe RegisterVideo do
      subject(:execute) { action.execute(user_id: user_id, youtube_id: youtube_id) }

      let(:action) { described_class.new(videos: videos) }

      let(:user_id) { :user }
      let(:youtube_id) { 'vO13R4p2vBA' }

      let(:registered_video) { :registered_video }

      let(:videos) { spy('videos', register: registered_video) }

      it 'registers the video' do
        execute

        expect(videos).to have_received(:register).with(owner: user_id, youtube_id: youtube_id)
      end

      it 'returns the registered video' do
        expect(execute).to eq registered_video
      end
    end
  end
end
