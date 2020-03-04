require 'rails_helper'

RSpec.describe AlertGroup, type: :model do
  it { should belong_to(:alert).touch(true).counter_cache(true) }
  it { should belong_to(:group) }
  it { should validate_presence_of(:alert_id) }
  it { should validate_presence_of(:group_id) }
end
