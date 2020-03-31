require 'rails_helper'

RSpec.describe Video, type: :model do
  describe '.register' do
    subject { Video.register(owner: user.id, youtube_id: youtube_id) }

    let(:user) { create(:user) }
    let(:youtube_id) { 'abc' }

    it 'creates a new video' do
      expect { subject }.to change { Video.count }.by 1
      expect(Video.first).to have_attributes(user: user, youtube_id: youtube_id)
    end
  end
end
