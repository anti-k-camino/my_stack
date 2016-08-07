require 'rails_helper'

RSpec.describe Question, type: :model do  

  it { should validate_presence_of :title }              
  it { should validate_presence_of :body } 
  it { should validate_presence_of :user_id }
  it { should have_db_index :title }
  it { should have_db_index :user_id }
  it { should have_many(:answers).dependent :destroy }
  it { should have_many(:votes).dependent :destroy }
  it { should have_many(:users) }
  it { should have_many(:attachments).dependent :destroy }
  it { should accept_nested_attributes_for :attachments }

  
  describe 'check_if_voted?' do 
    let!(:user){ create :user } 
    let!(:sample_user){ create :user }  
    let!(:question){ create :question }
    let!(:vote){ create :vote, user: user, votable: question, vote_field: 1}   
  
    it 'user different from resource user is accapteble' do
      expect(question.check_if_voted?(sample_user)).to be_falsy
    end
    it 'user similar to resource user is accapteble' do
      expect(question.check_if_voted?(user)).to be_truthy
    end
  end
end
