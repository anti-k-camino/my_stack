require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to(:subscriber).class_name('User').with_foreign_key('user_id') }  
  it { should belong_to :question }
  it { should have_db_index [:user_id, :question_id]}  
end
