require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :user }
  it { should belong_to :commentable }
  it { should have_db_index [:user_id, :commentable_type, :commentable_id] }
  it { should have_db_index [:commentable_type, :commentable_id] }
  it { should validate_presence_of :user }
  it { should validate_presence_of :commentable }
end
