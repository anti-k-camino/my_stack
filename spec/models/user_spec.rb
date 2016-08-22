require 'rails_helper'

RSpec.describe User, type: :model do 
  it { should validate_presence_of :name } 
  it { should validate_uniqueness_of(:name).case_insensitive } 
  it { should have_db_index :name }
  it { should have_many(:answers).dependent :destroy } 
  it { should have_many(:questions).dependent :destroy }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:votes).dependent :destroy }
  it { should have_many(:comments).dependent :destroy }
  
  let(:user){ create :user } 
  let(:user1){ create :user }
  let(:question){ create :question, user: user }
  let(:answer){create :answer, user: user}
  

  it "user is the author of a question" do
   expect(user).to be_author_of question 
  end   
  it "user is not the author of a question" do
   expect(user1).to_not be_author_of question 
  end
  it "user is the author of a answer" do
   expect(user).to be_author_of answer 
  end   
  it "user is not the author of an answer" do
   expect(user1).to_not be_author_of answer 
  end

end
