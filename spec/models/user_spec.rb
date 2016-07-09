require 'rails_helper'

RSpec.describe User, type: :model do 
  it { should validate_presence_of :name } 
  it { should validate_uniqueness_of(:name).case_insensitive } 
  it { should have_db_index :name }
  it { should have_many(:answers).dependent :destroy } 
  it { should have_many(:questions).dependent :destroy }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  
  let(:user){ create :user } 
  let(:user1){ create :user }
  let(:question){ create :question, user: user }
  let(:question1){ create :question, user: user1}

  it "returns true when user is the author || false when it is not" do    
    user.permission?(question).should == true
    user1.permission?(question).should == false
    user.permission?(question1).should == false
    user1.permission?(question1).should == true
  end

end
