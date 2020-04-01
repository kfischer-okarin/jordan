require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#sign_in' do
    subject { user.sign_in }

    let!(:user) { create(:user) }

    let(:decoded_token) { JWT.decode(subject, Rails.application.secrets.secret_key_base)[0] }

    around do |example|
      Timecop.freeze(Time.local(2020, 3, 30, 10, 0, 0)) do
        example.run
      end
    end

    it 'returns a token containing the user id' do
      expect(decoded_token).to match('exp' => 24.hours.from_now.to_i, 'user_id' => user.id)
    end

    it 'saves the token in the user' do
      subject

      expect(user.reload).to have_attributes(token: subject)
    end
  end
end
