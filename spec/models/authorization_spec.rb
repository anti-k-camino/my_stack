require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }
  it { should validate_presence_of :user }
  it { should have_db_index :user_id }
  it { should have_db_index [:provider, :uid] }
  it { should validate_uniqueness_of(:uid) }
end
