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

RSpec.shared_examples 'it handles client errors' do
  it 'returns 400 for invalid parameters' do
    allow(action).to receive(:execute).and_raise Jordan::Exceptions::InvalidParameters
    expect(subject).to have_http_status(:bad_request)
  end

  it 'returns 403 for missing permissions' do
    allow(action).to receive(:execute).and_raise Jordan::Exceptions::Forbidden
    expect(subject).to have_http_status(:forbidden)
  end

  it 'returns 404 for missing resources' do
    allow(action).to receive(:execute).and_raise ActiveRecord::RecordNotFound
    expect(subject).to have_http_status(:not_found)
  end
end
