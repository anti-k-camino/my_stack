require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }
  it { should belong_to :question }  
  it { should have_db_index :question_id }
  it { should belong_to :user }  
  it { should have_db_index :user_id }
  it { should have_many :attachments }
  it { should accept_nested_attributes_for :attachments }

  describe 'best!' do    
    let!(:question){ create :question }
    let!(:answer){ create :answer , question: question }
    let!(:best_answer){ create :answer, question: question, best: true }   
    before do
      answer.the_best!  #ze best  ))))
    end
    
    it 'expect the best! to change answer.best to true' do                 
      expect(answer).to be_best      
    end

    it 'expect best_answer to not be best' do
      best_answer.reload
      expect(best_answer).to_not be_best
    end
  end

  describe 'check_if_voted?' do 
    let!(:user){ create :user } 
    let!(:sample_user){ create :user }  
    let!(:answer){ create :answer }
    let!(:vote){ create :vote, user: user, votable: answer, vote_field: 1}   
  
    it 'user different from resource user is accapteble' do
      expect(answer.check_if_voted?(sample_user)).to be_falsy
    end
    it 'user similar to resource user is accapteble' do
      expect(answer.check_if_voted?(user)).to be_truthy
    end
  end
end
