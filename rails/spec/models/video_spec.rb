require 'rails_helper'

RSpec.describe Video, type: :model do
  describe Video::Gateway do
    describe '.register' do
      subject { described_class.register(owner: user.id, youtube_id: youtube_id) }

      let(:user) { create(:user) }
      let(:youtube_id) { 'abc' }

      it 'creates a new video' do
        expect { subject }.to change { Video.count }.by 1
        expect(Video.first).to have_attributes(user: user, youtube_id: youtube_id)
      end
    end

    describe '.get_by_youtube_id' do
      subject { described_class.get_by_youtube_id(youtube_id) }

      let(:user) { create(:user) }
      let!(:video) { create(:video, user: user) }
      let(:youtube_id) { video.youtube_id }

      it 'returns the video entity' do
        expect(subject).to be_a(Jordan::Entities::Video) & have_attributes(owner: user.id)
      end
    end
  end
end
