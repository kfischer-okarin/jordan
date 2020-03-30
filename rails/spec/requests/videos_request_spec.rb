require 'rails_helper'

RSpec.describe "Videos", type: :request do
  describe 'PUT /videos/{youtube_id}' do
    def headers_for(user)
      { Authorization: "Bearer #{user.token}" }
    end

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

      describe 'Authentication' do
        context 'Without an authentication token' do
          let(:request_headers) { {} }

          it { is_expected.to have_http_status(:unauthorized) }
        end

        context 'With an invalid token' do
          let(:request_headers) { { Authorization: 'Bearer abc' } }

          it { is_expected.to have_http_status(:unauthorized) }
        end

        it 'rejects expired tokens' do
          Timecop.freeze(2.days.from_now) do
            expect(subject).to have_http_status(:unauthorized)
          end
        end
      end
    end
  end
end
