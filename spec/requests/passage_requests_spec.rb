require 'rails_helper'

RSpec.describe "Passages", type: :request do
  describe 'GET /passage: Get a bible passage' do
    subject {
      get "/passage", params: params
      response
    }

    let(:params) { { passage: 'John 3:16', type: 'json' } }
    let(:verse) { 'For this is' }

    before do
      allow(PassagesController).to receive(:get).with('http://labs.bible.org/api/', query: params).and_return(verse)
    end

    it 'forwards the request to the Bible API' do
      subject
      expect(PassagesController).to have_received(:get).with('http://labs.bible.org/api/', query: params)
    end

    it 'returns the response of the Bible API' do
      expect(subject).to have_http_status(:ok)
      expect(subject.body).to eq verse
    end
  end
end
