require 'rails_helper'

describe User do
  describe 'validation' do
    let(:user) { create(:user) }
    let(:invalid_user) { build(:user, email: nil) }
    context 'when user provided email' do
      it 'has valid factory' do 
        expect(build(:user)).to be_valid 
      end
    end

    context 'when email are missing' do
      it 'it is invalid' do
        expect(invalid_user).to be_invalid
      end
    end

    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
  end
end
