require 'rails_helper'

RSpec.describe AlertKeyword, type: :model do
  it { should belong_to(:alert).touch(true).counter_cache(true) }
  it { should belong_to(:keyword) }
end
