# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  email                :string(255)
#  phone                :string(255)
#  password_digest      :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  role                 :string(255)
#  email_alert          :boolean          default(FALSE)
#  sms_alert            :boolean          default(FALSE)
#  full_name            :string(255)
#  auth_token           :string(255)
#  confirmed_token      :string(255)
#  confirmed_at         :datetime
#  reset_password_token :string(255)
#  reset_password_at    :datetime
#  channels_count       :integer          default(0)
#

require 'rails_helper'

RSpec.describe User, :type => :model do
  describe "relationship" do
    it { should have_many(:group_messages) }
    it { should have_many(:channels) }
    it { should have_many(:keyword_sets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:full_name)}
    it { should validate_confirmation_of(:password)}
    it { should validate_length_of(:password).is_at_least(6).is_at_most(72) }
    it { should validate_uniqueness_of(:email)}
  end

  describe User, '.authenticate' do
    context 'allow admin user login' do
      it "with correct username/password system authenticates user" do
        user = create(:user, email: 'vicheka@feedalert.com', password: 'password')

        result = User.authenticate('vicheka@feedalert.com', 'password')

        expect(result).to eq(user)
      end

      it 'reject user if email/password incorrect' do
        create(:user, email: 'user@example.com', password: 'incorrect')

        result = User.authenticate('user@example.com', 'password')

        expect(result).to eq(false)
      end

    end
  end

  describe User, '#change_password' do
    let(:user) { create(:user, email: 'vicheka@feedalert.com', password: 'password')}
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

  describe User, 'on create' do
    it "generate auth_token for permanent login" do
      user = create(:user)
      expect(user.auth_token).to be_present
    end

    it "generate confirmed_token for email confirmation" do
      user = create(:user)
      expect(user.confirmed_token).to be_present
    end

    it 'set default role to Normal if not present' do
      user = create(:user, role: nil)
      expect(user.role).to eq User::ROLE_NORMAL
    end
  end

  describe User, 'on before save' do
    it "downcase the email for case insensitive login" do
      user = create(:user, email: 'Channa.Info@gmail.com')
      expect(user.email).to eq 'channa.info@gmail.com'
    end
  end

  describe User, '.project_with_admin_permission' do
    let(:user) { create(:user, role: nil) }
    before{
      @health = create(:project, user_id: user.id)
      @education = create(:project, user_id: user.id)
    }
    context 'with the projects' do
      it "return the projects" do
        expect(user.project_with_admin_permission).to include @health, @education
        expect(user.project_with_admin_permission).to eq [@health, @education]
      end
    end

    context 'with the shared projects' do
      before{
        @environment = create(:project)
        @agriculture = create(:project)

        create(:project_permission, user_id: user.id, project_id: @environment.id, role: User::PERMISSION_ROLE_ADMIN)
        create(:project_permission, user_id: user.id, project_id: @agriculture.id, role: User::PERMISSION_ROLE_NORMAL)
      }
      it "return the projects and the shared_project with admin role" do
        expect(user.project_with_admin_permission).to include @health, @education, @environment
        expect(user.project_with_admin_permission).to eq [@health, @education, @environment]
      end

      it "does not return the shared_project with non_admin role" do
        expect(user.project_with_admin_permission).not_to include @agriculture
      end
    end
  end

end
