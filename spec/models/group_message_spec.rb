require 'rails_helper'

RSpec.describe GroupMessage, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:receiver_groups).with_message("Receiver's group cannot be blank")}
  end
end
