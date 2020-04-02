RSpec.shared_examples 'an authenticated endpoint' do
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
