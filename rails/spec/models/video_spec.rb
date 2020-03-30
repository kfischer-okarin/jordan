require 'rails_helper'

RSpec.describe Video, type: :model do
  describe '.register' do
    subject { Video.register(owner: user_id, youtube_id: youtube_id) }

    let(:user_id) { 1 }
    let(:youtube_id) { 'abc' }

    it 'creates a new video' do
      expect { subject }.to change { Video.count }.by 1
      expect(Video.first).to have_attributes(user_id: user_id, youtube_id: youtube_id)
    end
  end
end
