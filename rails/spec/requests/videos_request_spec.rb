require 'rails_helper'

RSpec.describe "Videos", type: :request do
  describe 'PUT /videos/{youtube_id}: Register video' do
    let(:request_headers) { headers_for(user) }

    subject {
      put "/videos/#{youtube_id}", headers: request_headers
      response
    }

    let(:user) { create(:user) }
    let(:youtube_id) { 'xyz' }

    before do
      user.sign_in
    end

    describe 'Integration' do
      it 'registers a video' do
        expect { subject }.to change { Video.count }.by 1
        expect(Video.first).to have_attributes(youtube_id: youtube_id, user_id: user.id)
      end
    end

    describe 'Unit' do
      let(:action) { spy('Jordan::Actions::RegisterVideo') }

      before do
        allow(Jordan::Actions::RegisterVideo).to receive(:new).and_return(action)
      end

      it 'calls Jordan::Actions::RegisterVideo' do
        subject

        expect(action).to have_received(:execute).with(user_id: user.id, youtube_id: youtube_id)
      end

      it_behaves_like 'an authenticated endpoint'
    end
  end
end
