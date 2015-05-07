require 'rails_helper'

RSpec.describe User, :type => :model do
  describe 'validations' do

    it { should validate_confirmation_of(:password)}
    it { should validate_length_of(:password).is_at_least(6).is_at_most(72) }
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

  describe User, '#change_password' do
    let(:user) { create(:user, user_name: 'vicheka', password: 'password')}
    context 'with valid passsword' do
      it "return true" do
        result = user.change_password('password', 'new_password', 'new_password')
        expect(result).to eq true
      end
    end

    context 'with invalid password' do
      it 'return false with Old password does not matched error message' do
        result = user.change_password('incorrect', 'new_password', 'new_password')
        expect(result).to eq false
        expect(user.errors.full_messages).to eq ["Old password does not matched"]
      end

      it 'return false with password does not matched' do
        result = user.change_password('password', 'missmatch', 'password')
        expect(user.errors.full_messages).to eq ["Password confirmation doesn't match Password"]
        expect(result).to eq false
      end
    end

  end

end
