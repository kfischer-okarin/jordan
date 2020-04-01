require 'rails_helper'

RSpec.describe "Annotations", type: :request do
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

    describe 'Integration' do
      it 'returns the created annotatiion' do
        expect(subject).to have_http_status(:created)

        created = Annotation.first
        expect(subject.parsed_body).to match('id' => created.id, 'payload' => payload, 'position' => nil)
      end

      it 'adds an annotation video' do
        expect { subject }.to change { Annotation.count }.by 1
        expect(Annotation.first).to have_attributes(video: video, payload: payload, position: nil)
      end
    end

    describe 'Unit' do
      let(:action) { spy('Jordan::Actions::AddAnnotation', execute: created_annotation) }
      let(:created_annotation) {
        Jordan::Entities::Annotation.new(id: 1, youtube_id: youtube_id, position: nil, payload: payload)
      }

      before do
        allow(Jordan::Actions::AddAnnotation).to receive(:new).and_return(action)
      end

      it 'calls Jordan::Actions::AddAnnotation' do
        subject

        expect(action).to have_received(:execute).with(user_id: user.id, youtube_id: youtube_id, payload: payload)
      end

      include_examples 'it handles client errors'
      it_behaves_like 'an authenticated endpoint'
    end
  end

  describe 'POST /annotations/{annotation_id}/publish: Publish annotation' do
    let(:request_headers) { headers_for(user) }

    subject {
      post "/annotations/#{annotation.id}/publish", params: { position: position }, headers: request_headers
      response
    }

    let(:user) { create(:user) }
    let(:video) { create(:video, user: user) }
    let(:annotation) { create(:annotation, video: video) }

    let(:position) { 10 }

    before do
      user.sign_in
    end

    describe 'Integration' do
      before do
        allow(ActionCable.server).to receive(:broadcast)
      end

      it { is_expected.to have_http_status(:ok) }

      it 'updates the annotation to the specified position' do
        expect { subject }.to change { annotation.reload.position }.from(nil).to(position)
      end

      it 'sends a message to the ViewerChannel of the video' do
        subject

        expect(ActionCable.server).to have_received(:broadcast).with(
          video.youtube_id,
          { position: position, payload: annotation.payload }
        )
      end
    end

    describe 'Unit' do
      let(:action) { spy('Jordan::Actions::PublishAnnotation') }

      before do
        allow(Jordan::Actions::PublishAnnotation).to receive(:new).and_return(action)
      end

      it 'calls Jordan::Actions::PublishAnnotation' do
        subject

        expect(action).to have_received(:execute).with(user_id: user.id, position: position, annotation_id: annotation.id)
      end

      it_behaves_like 'an authenticated endpoint'
      include_examples 'it handles client errors'
    end
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

    describe 'Integration' do
      it { is_expected.to have_http_status(:no_content) }

      it 'removes the annotation' do
        expect { subject }.to change { Annotation.count }.by(-1)
        expect(Annotation.find_by(id: annotation_id)).to be_nil
      end
    end

    describe 'Unit' do
      let(:action) { spy('Jordan::Actions::DeleteAnnotation') }

      before do
        allow(Jordan::Actions::DeleteAnnotation).to receive(:new).and_return(action)
      end

      it 'calls Jordan::Actions::DeleteAnnotation' do
        subject

        expect(action).to have_received(:execute).with(user_id: user.id, annotation_id: annotation.id)
      end

      it_behaves_like 'an authenticated endpoint'
      include_examples 'it handles client errors'
    end
  end
end
