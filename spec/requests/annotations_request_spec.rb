require 'rails_helper'

RSpec.describe "Annotations", type: :request do
  describe 'GET /videos/{youtube_id}/annotations: Get all annotation' do
    subject {
      get "/videos/#{youtube_id}/annotations", headers: request_headers
      response
    }

    let(:user) { create(:user) }
    let(:video) { create(:video, youtube_id: 'xyz', user: user) }
    let(:youtube_id) { video.youtube_id }
    let!(:annotations) {
      [
        create(:annotation, video: video, video_timestamp: nil),
        create(:annotation, video: video, video_timestamp: 30),
        create(:annotation, video: video, video_timestamp: 20)
      ]
    }

    before do
      create(:annotation) # Unrelated annotation
      user.sign_in
    end

    context 'When the user is video owner' do
      let(:request_headers) { headers_for(user) }

      it 'returns the all annotations of the video' do
        expect(subject).to have_http_status(:ok)
        expect(subject.parsed_body).to eq [
          {'id' => annotations[0].id, 'payload' => annotations[0].payload, 'video_timestamp' => annotations[0].video_timestamp},
          {'id' => annotations[1].id, 'payload' => annotations[1].payload, 'video_timestamp' => annotations[1].video_timestamp},
          {'id' => annotations[2].id, 'payload' => annotations[2].payload, 'video_timestamp' => annotations[2].video_timestamp}
        ]
      end
    end

    context 'When the user is not video owner' do
      let(:request_headers) { {} }

      it 'returns the all published annotations of the video' do
        expect(subject).to have_http_status(:ok)
        expect(subject.parsed_body).to eq [
          {'payload' => annotations[2].payload, 'video_timestamp' => annotations[2].video_timestamp},
          {'payload' => annotations[1].payload, 'video_timestamp' => annotations[1].video_timestamp}
        ]
      end
    end
  end

  describe 'POST /videos/{youtube_id}/annotations: Add annotation' do
    let(:request_headers) { headers_for(user) }

    subject {
      post "/videos/#{youtube_id}/annotations", params: { payload: payload }, headers: request_headers
      response
    }

    let(:user) { create(:user) }
    let(:video) { create(:video, user: user) }
    let(:youtube_id) { video.youtube_id }
    let(:payload) { { 'type' => 'bible_verse', 'passage' => 'Matthew 6:33' } }

    before do
      user.sign_in
    end

    it 'returns the created annotatiion' do
      expect(subject).to have_http_status(:created)

      created = Annotation.first
      expect(subject.parsed_body).to match('id' => created.id, 'payload' => payload, 'video_timestamp' => nil)
    end

    it 'adds an annotation video' do
      expect { subject }.to change { Annotation.count }.by 1
      expect(Annotation.first).to have_attributes(video: video, payload: payload, video_timestamp: nil)
    end

    it_behaves_like 'an authenticated endpoint'
  end

  describe 'POST /annotations/{annotation_id}/publish: Publish annotation' do
    let(:request_headers) { headers_for(user) }

    subject {
      post "/annotations/#{annotation.id}/publish", params: { annotation: params }, headers: request_headers
      response
    }

    let(:user) { create(:user) }
    let(:video) { create(:video, user: user) }
    let(:annotation) { create(:annotation, video: video) }
    let(:params) { { video_timestamp: video_timestamp } }

    let(:video_timestamp) { 10 }

    before do
      user.sign_in
      allow(ActionCable.server).to receive(:broadcast)
    end

    it { is_expected.to have_http_status(:ok) }

    it 'updates the annotation to the specified position' do
      expect { subject }.to change { annotation.reload.video_timestamp }.from(nil).to(video_timestamp)
    end

    it 'sends a message to the ViewerChannel of the video' do
      subject

      expect(ActionCable.server).to have_received(:broadcast).with(
        video.youtube_id,
        { video_timestamp: video_timestamp, payload: annotation.payload }
      )
    end

    context 'When the video was upcoming' do
      before do
        video.update(status: 'upcoming')
      end

      it 'changes the status to streaming' do
        expect { subject }.to change { video.reload.status }.from('upcoming').to('streaming')
      end
    end

    context 'When the video was streaming' do
      before do
        video.update(status: 'streaming')
      end

      it 'does not change the status' do
        expect { subject }.not_to change { video.reload.status }
      end
    end

    context 'When the video was streamed' do
      before do
        video.update(status: 'streamed')
      end

      it 'returns 422' do
        expect(subject).to have_http_status(:unprocessable_entity)
      end
    end

    it_behaves_like 'an authenticated endpoint'
  end

  describe 'PATCH /annotations/{annotation_id}: Edit annotation' do
    let(:request_headers) { headers_for(user) }

    subject {
      patch "/annotations/#{annotation_id}", params: { annotation: params }, headers: request_headers
      response
    }

    let(:user) { create(:user) }
    let(:video) { create(:video, user: user) }
    let!(:annotation) { create(:annotation, video: video) }
    let(:annotation_id) { annotation.id }
    let(:new_payload) { { 'new_content' => 'aaa' }  }
    let(:params) { { payload: new_payload}}

    before do
      user.sign_in
    end

    it 'returns the updated annotation' do
      expect(subject).to have_http_status(:ok)
      expect(subject.parsed_body).to eq({
        'id' => annotation.id,
        'payload' => new_payload,
        'video_timestamp' => annotation.video_timestamp
      })
    end

    it 'updates the annotation' do
      old_payload = annotation.payload
      expect { subject }.to change { annotation.reload.payload }.from(old_payload).to(new_payload)
    end

    it_behaves_like 'an authenticated endpoint'
  end

  describe 'DELETE /annotations/{annotation_id}: Delete annotation' do
    let(:request_headers) { headers_for(user) }

    subject {
      delete "/annotations/#{annotation_id}", headers: request_headers
      response
    }

    let(:user) { create(:user) }
    let(:video) { create(:video, user: user) }
    let!(:annotation) { create(:annotation, video: video) }
    let(:annotation_id) { annotation.id }

    before do
      user.sign_in
    end

    it { is_expected.to have_http_status(:no_content) }

    it 'removes the annotation' do
      expect { subject }.to change { Annotation.count }.by(-1)
      expect(Annotation.find_by(id: annotation_id)).to be_nil
    end

    it_behaves_like 'an authenticated endpoint'
  end

  describe 'PUT /videos/{youtube_id}/annotations/order: Rearrange annotations' do
    let(:request_headers) { headers_for(user) }

    subject {
      put "/videos/#{youtube_id}/annotations/order", params: { _json: new_order }, headers: request_headers
      response
    }

    let(:user) { create(:user) }
    let(:video) { create(:video, user: user) }
    let(:youtube_id) { video.youtube_id }
    let!(:annotations) {
      create_list(:annotation, 3, video: video)
    }

    let(:new_order) { [2, 0, 1].map { |i| annotations[i].id } }

    before do
      user.sign_in
    end

    it { is_expected.to have_http_status(:ok) }

    it 'reorders the annotations' do
      expect { subject }.to change {
        annotations.map(&:reload)
        annotations.map(&:position)
      }.from([1, 2, 3]).to([2, 3, 1])
    end

    it_behaves_like 'an authenticated endpoint'
  end
end
