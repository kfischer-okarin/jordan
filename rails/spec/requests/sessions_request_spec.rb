require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe 'POST /sessions' do
    subject {
      post "/sessions", params: { idtoken: idtoken }
      response
    }

    let(:idtoken) { 'token' }

    context 'With a valid token' do
      let(:google_user_id) { 'userid' }
      let(:name) { 'James Cole' }
      let(:email) { 'james.cole@west7.com' }
      let(:payload) { { 'sub' => google_user_id, 'name' => name, 'email' => email } }

      before do
        allow_any_instance_of(GoogleIDToken::Validator).to receive(:check).and_return(payload)
      end

      it { is_expected.to have_http_status(:ok) }

      context 'if the user does not exist yet' do
        it 'creates a new user with the attributes from Google' do
          expect { subject }.to change { User.count }.by 1
          expect(User.all).to contain_exactly(
            an_object_having_attributes(provider: 'google', user_id: google_user_id, name: name, email: email)
          )
        end
      end

      context 'if the user exists' do
        before do
          create(:google_user, user_id: google_user_id, name: 'Bob', email: 'bob@example.com')
        end

        it 'creates no new user' do
          expect { subject }.to change { User.count }.by 0
        end

        it 'creates no new user' do
          subject

          expect(User.find_by(user_id: google_user_id)).to have_attributes(name: name, email: email)
        end
      end
    end

    context 'With an invalid token' do
      before do
        allow_any_instance_of(GoogleIDToken::Validator).to receive(:check).and_raise(GoogleIDToken::ValidationError)
      end

      it { is_expected.to have_http_status(:unauthorized) }
    end
  end
end
