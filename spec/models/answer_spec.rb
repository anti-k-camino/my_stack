require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }
  it { should belong_to :question }  
  it { should have_db_index :question_id }
  it { should belong_to :user }  
  it { should have_db_index :user_id }

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
end
