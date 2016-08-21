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

        it 'response with propper json' do
          post :create, comment:{body: 'test'}, question_id: question, format: :json
          expect(JSON.parse(response.body)["comment"]["body"]).to eq "test"
          expect(JSON.parse(response.body)["user_name"]).to eq @user.name
        end
      end

      context 'invalid attributes' do
        it 'does not change question comments quantity' do
          expect{ post :create, comment:{ user: @user }, question_id: question, format: :json }.to_not change(question.comments, :count)
        end

        it 'responds with error' do
          post :create, comment:{ body: ""}, question_id: question, format: :json
          expect(JSON.parse(response.body)["errors"][0]).to eq "Body can't be blank"
        end
      end
    end

    context 'Non authenticated user' do
      let!(:question){ create :question }

      it 'does not create a comment' do
        expect{ post :create, comment:{ body: "body"}, question_id: question, format: :json }.to_not change(question.comments, :count)
      end
    end
  end

  describe 'Destroy#delete' do
    context 'Authenticated user' do
      sign_in_user
      let!(:another_user){ create :user }
      let!(:question){ create :question }     
      let!(:comment){ create :comment, body: 'some body', commentable: question, user: @user }
      let!(:another_comment){ create :comment, body: 'another body', commentable: question, user: another_user }

      context 'author of comment' do
        it 'deletes a comment' do          
          expect{ delete :destroy, id: comment, format: :js}.to change(question.comments, :count).by -1
        end

        it 'renders destroy' do
          delete :destroy, id: comment, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'non author of a comment' do
        it 'does not delete comment' do
          expect{ delete :destroy, id: another_comment, format: :js }.to_not change(question.comments, :count)
        end
      end

    end
    context 'Non authenticated user' do
    end
  end
end

