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

class UserSerializer < ActiveModel::Serializer
  attributes :id, :email
  has_many :project_permissions
  has_many :channel_permissions
end
