require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe 'Create#patch' do
    context 'Authenticated user' do
      sign_in_user
      let!(:question){ create :question }

      context 'valid attributes' do
        it 'changes question comments quantity' do       
          expect{ post :create, comment:{body: 'test'}, question_id: question, format: :json}.to change(question.comments, :count).by 1
        end
      end

      context 'invalid attributes' do
        it 'does not change question comments quantity' do
          expect{ post :create, comment:{ user: @user }, question_id: question, format: :json }.to_not change(question.comments, :count)
        end
      end

    end
  end
end
