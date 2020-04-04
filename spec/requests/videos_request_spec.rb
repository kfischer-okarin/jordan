require 'rails_helper'

RSpec.describe "Videos", type: :request do
  describe 'GET /videos: Get your video' do
    subject {
      get "/videos", headers: request_headers
      response
    }

    let(:user) { create(:user) }
    let!(:videos) { create_list(:video, 3, user: user) }
    let!(:other_video) { create(:video) }

    before do
      user.sign_in
    end

    context 'When the user is logged in' do
      let(:request_headers) { headers_for(user) }

      it 'returns own videos' do
        expect(subject).to have_http_status(:ok)
        expect(subject.parsed_body).to contain_exactly(*videos.map { |v|
          { 'youtube_id' => v.youtube_id, 'status' => v.status, 'title' => v.title, 'user' => { 'name' => user.name }  }
        })
      end
    end

    context 'When the user is not logged in' do
      let(:request_headers) { {} }
      it 'returns all videos' do
        expect(subject).to have_http_status(:ok)
        expect(subject.parsed_body).to contain_exactly(*(videos + [other_video]).map { |v|
          { 'youtube_id' => v.youtube_id, 'status' => v.status, 'title' => v.title, 'user' => { 'name' => user.name } }
        })
      end
    end
  end

  describe 'PUT /videos/{youtube_id}: Register video' do
    let(:request_headers) { headers_for(user) }

    subject {
      put "/videos/#{youtube_id}", params: { video: params }, headers: request_headers
      response
    }

    let(:user) { create(:user) }
    let(:youtube_id) { 'xyz' }
    let(:title) { 'Creation' }
    let(:params) { { 'title': title } }

    before do
      user.sign_in
    end

    it 'registers a video' do
      expect { subject }.to change { Video.count }.by 1
      expect(Video.first).to have_attributes(youtube_id: youtube_id, user_id: user.id, title: title, status: 'upcoming')
    end

    it 'returns the registered video' do
      expect(subject).to have_http_status(:ok)
      expect(subject.parsed_body).to eq({
        'youtube_id' => youtube_id,
        'title' => title,
        'user' => { 'name' => user.name },
        'status' => 'upcoming'
      })
    end

    context 'When the video already exists' do
      before do
        create(:video, youtube_id: youtube_id)
      end

      it 'does not register a video' do
        expect { subject }.not_to change { Video.count }
        expect(subject).to have_http_status(:unprocessable_entity)
      end
    end

    it_behaves_like 'an authenticated endpoint'
  end

  describe 'GET /videos/{youtube_id}: Get video' do
    subject {
      get "/videos/#{youtube_id}"
      response
    }

    let(:user) { create(:user) }
    let(:video) { create(:video, user: user, status: 'streaming') }
    let(:youtube_id) { video.youtube_id }

    before do
      user.sign_in
    end

    it 'returns the video' do
      expect(subject).to have_http_status(:ok)
      expect(subject.parsed_body).to eq({
        'youtube_id' => youtube_id,
        'status' => video.status,
        'title' => video.title,
        'user' => { 'name' => user.name }
      })
    end
  end

  describe 'PATCH /videos/{youtube_id}: Update video state' do
    let(:request_headers) { headers_for(user) }

    subject {
      patch "/videos/#{youtube_id}", params: params, headers: request_headers
      response
    }

    let(:user) { create(:user) }
    let!(:video) { create(:video, user: user, youtube_id: youtube_id, status: 'upcoming') }
    let(:youtube_id) { 'xyz' }
    let(:status) { 'streaming' }
    let(:params) { { status: status } }

    before do
      user.sign_in
    end

    it 'returns the updated video' do
      expect(subject).to have_http_status(:ok)
      expect(subject.parsed_body).to eq({ 'youtube_id' => youtube_id, 'status' => status, 'title' => video.title })
    end

    it 'updates the video status' do
      expect { subject }.to change { video.reload.status }.to status
    end

    context 'When the video is not owned by the user exists' do
      let(:video) { create(:video, user: create(:user), youtube_id: youtube_id, status: 'upcoming') }

      it 'returns 403' do
        expect(subject).to have_http_status(:forbidden)
      end
    end

    context 'With unknown params' do
      let(:params) { { unknown: 'abb' } }

      it 'returns 400' do
        expect(subject).to have_http_status(:bad_request)
      end
    end

    it_behaves_like 'an authenticated endpoint'
  end
end
