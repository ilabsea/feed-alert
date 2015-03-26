require 'rails_helper'

RSpec.describe User, :type => :model do
  describe 'validations' do

    it { should validate_confirmation_of(:password)}
    it { should ensure_length_of(:password).is_at_least(6).is_at_most(72) }
    it { should validate_uniqueness_of(:user_name)}
  end

  describe User, '.authenticate' do
    context 'allow admin user login' do
      it "with correct username/password system authenticates user" do
        user = create(:user, user_name: 'vicheka', password: 'password')

        result = User.authenticate('vicheka', 'password')

        expect(result).to eq(user)
      end

      it 'reject user if user_name/password incorrect' do
        create(:user, user_name: 'user@example.com', password: 'incorrect')

        result = User.authenticate('user@example.com', 'password')

        expect(result).to eq(false)
      end

    end
  end

end
