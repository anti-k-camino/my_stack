require 'rails_helper'

RSpec.describe Question, type: :model do  

  it { should validate_presence_of :title }              
  it { should validate_presence_of :body } 
  it { should validate_presence_of :user_id }
  it { should have_db_index :title }
  it { should have_db_index :user_id }
  it { should have_many(:answers).dependent :destroy }

  describe 'has best?' do
    let!(:question_with_best){ create :question }
    let!(:answer){ create :vote_answer, question: question_with_best, best: true }
    let!(:question_without_best){ create :question }
    let!(:answer_average){ create :vote_answer, question: question_with_best }

    it 'returns true if there is a best answer' do
      expect(question_with_best.has_best?).to eq true
    end

    it 'returns false if there is no best answer yet' do
      expect(question_without_best.has_best?).to eq false
    end

  end  

end
