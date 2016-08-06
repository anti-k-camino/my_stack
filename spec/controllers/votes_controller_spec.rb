require 'rails_helper'

RSpec.describe VotesController, type: :controller do   
  describe 'DELETE #destroy' do
    context 'Non authenticated user' do      
      let!(:question){ create :question }
      let!(:vote){ create :vote, user_id: 1, votable_type: 'Question', votable_id: question.id, vote_field: 1 }

      it 'does not delete vote' do
        expect{ delete :destroy, id: vote, format: :json }.to_not change(Vote, :count)
      end
      
    end

    context 'Authenticated user 'do
      sign_in_user
      let!(:question){ create :question }
      context 'author of a vote' do        
        let!(:vote){ create :vote, user: @user, votable_type: 'Question', votable_id: question.id, vote_field: 1 }

        it 'deletes a vote' do
          expect{ delete :destroy, id: vote, format: :json }.to change(Vote, :count).by -1
        end

        it 'changes resources votes count' do
          expect{ delete :destroy, id: vote, format: :json }.to change(question.votes, :count).by -1
        end

        it 'returns propper json' do
          delete :destroy, id: vote, format: :json          
          expect(JSON.parse(response.body)["rating"]).to eq 0 
          expect(JSON.parse(response.body)["votable"]).to eq question.id         
        end

      end
      context 'not the author of a vote' do        
        let!(:vote){ create :vote, user_id: 201, votable_type: 'Question', votable_id: question.id, vote_field: 1 }
        
        it 'does not delete a vote' do
          expect{ delete :destroy, id: vote, format: :json }.to_not change(question.votes, :count)
        end 

      end      
    end
  end
end