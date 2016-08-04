require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should validate_presence_of :user_id } 
  it { should validate_presence_of :votable }
  it { should validate_presence_of :vote_field } 
  it { should have_db_index [:user_id, :votable_id, :votable_type] }
end