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

FactoryGirl.define do
  factory :alert do
    name "MyString"
    url "MyString"
    sms_template "MyText"
    from_time "10:00"
    to_time "12:00"
  end

end
