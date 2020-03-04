# == Schema Information
#
# Table name: alerts
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  url                  :string(255)
#  interval             :float(24)
#  interval_unit        :string(255)
#  email_template       :text(65535)
#  sms_template         :text(65535)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  alert_places_count   :integer          default(0)
#  alert_groups_count   :integer          default(0)
#  alert_keywords_count :integer          default(0)
#  from_time            :string(255)
#  to_time              :string(255)
#  project_id           :integer
#  channel_id           :integer
#

require 'rails_helper'

RSpec.describe Alert, type: :model do
  it { should have_many(:groups).through(:alert_groups) }
  it { should have_many(:alert_groups).dependent(:destroy) }
  it { should have_many(:keyword_sets).through(:alert_keyword_sets) }
  it { should have_many(:alert_keyword_sets).dependent(:destroy) }
  it { should have_many(:places).through(:alert_places) }
  it { should have_many(:alert_places).dependent(:destroy) }
  it { should have_many(:feeds).dependent(:destroy) }
  it { should have_many(:members).through(:groups) }
  it { should belong_to(:project) }
  it { should belong_to(:channel) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:url) }
end
