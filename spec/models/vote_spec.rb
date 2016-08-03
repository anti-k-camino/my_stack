require 'rails_helper'

RSpec.describe Vote, type: :model do
  
  it{ should validate_presence_of :user }
  it{ should validate_presence_of :votable }
  it{ should validate_presence_of :vote_field }

  describe 'vote_up!' do 
    let!(:user){ create :user }          
    let!(:question){ create :question }    
    let!(:vote){ create :vote_questions, votable: question, vote_field: true, user: user }   
    before do
      question.votes.build.vote_up!
        


    end
    
    it 'expect the best! to change answer.best to true' do                 
      expect(question.votes.last).to be_best      
    end    
  end
  
end
