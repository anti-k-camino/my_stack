require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question){ create :question } 
  let(:question_with_answers){ create(:question_with_answers) }
  let(:answer){ create :answer }

  describe 'GET #index' do    
    before{ get :index, question_id: question_with_answers }
    it 'populates an array of answers to question' do      
      expect(assigns :answers).to match_array question_with_answers.answers
    end
    it 'renders view index' do 
    end
  end

  describe 'GET #new' do
    sign_in_user
    before{ get :new, question_id: question }
    it 'assigns Answer to @answer' do
      expect(assigns :answer).to be_a_new Answer
    end
    it 'renders view new' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do    
    before{ get :show, id: answer }
    it 'assigns reqested answer to @answer' do
      expect(assigns :answer).to eq answer
    end
    it 'renders view show' do
      expect(response).to render_template :show
    end
  end
=begin

  describe 'GET #edit' do
    sign_in_user 
    context 'current user is the author of an answer' do
      let(:answer){ create :answer, user: @user }   
      before{ get :edit, id: answer }
      it 'assigns required answer to @answer' do
        expect(assigns :answer).to eq answer
      end
      it 'renders view edit' do
        expect(response).to render_template :edit
      end
    end
    context 'curent user is not the author of a answer' do
      malicious_case
      before{ get :edit, id: answer }  
      it 'assigns required answer to @answer' do
        expect(assigns :answer).to eq answer
      end
      it 'redirects view show question' do
        expect(response).to redirect_to question_path answer.question,  notice:'Restricted'
      end
    end
  end
=end


  describe 'POST #create' do
    sign_in_user    
    context 'valid parameters' do      
      it 'saves new answer to db' do
        expect{ post :create, question_id: question, answer:{ body:'TestBody', user: @user } }.to change(question.answers, :count).by 1
      end
      it 'changes author user answers' do
        expect{ post :create, question_id: question, answer:{ body:'TestBody', user: @user } }.to change(@user.answers, :count).by 1
      end
      it 'redirects to view question show' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(assigns :question)
      end
    end
    context 'invalid parameters' do
      it 'does not save answer to db' do
        expect{ post :create, question_id: question, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)      
      end
      it 'renders view new' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    context 'user is author of an answer' do
      let(:answer){ create :answer, user: @user}
      context 'with valid attributes' do
        it 'assigns answer to @answer' do
          patch :update, id: answer, answer: attributes_for(:answer)
          expect(assigns :answer).to eq answer          
        end 
        it 'answer has a user as an author' do
          patch :update, id: answer, answer: { body: 'TestAnswerBody', user: @user }
          answer.reload           
          expect(@user.answers.last.body).to eq answer.body
        end 
        it 'changes answer attributes' do
          patch :update, id: answer, answer: { body: 'NewBody' }
          answer.reload          
          expect(answer.body).to eq 'NewBody'
        end 
        it 'redirects to answer question' do
          patch :update, id: answer, answer: { body: 'NewBody' }
          expect(response).to redirect_to question_path answer.question, notice:'Your answer successfully updated'
        end   
      end
      context 'with invalid attriutes' do 
        before do
          patch :update, id: answer, answer: { body: nil }          
          @body = answer.body
        end
        it 'does not change answer attributes' do           
          expect(answer.body).to eq @body
        end
        it 'renders view edit' do                
          expect(response).to render_template :edit
        end
      end
    end    
    context 'user is not author of an answer' do
      malicious_case
      before do
        patch :update, id: answer, answer: attributes_for(:answer)
        @body = answer.body
      end      
      it 'does not modify @answer' do        
        expect(answer.body).to eq @body        
      end
      it 'redirects to view show question answers' do        
        expect(response).to redirect_to question_path answer.question, notice: 'Restricted'
      end
    end
  end

  describe 'DELETE #destroy' do       
    sign_in_user    
    context 'current user is the author of an answer' do 
      let(:answer){ create :answer, user: @user }
      
      it 'deletes answer' do
        answer      
        expect{ delete :destroy, id: answer }.to change(@user.answers, :count).by -1
        #expect{ delete :destroy, id: answer }.to change(answer.question, :count).by -1 
      end
      it 'redirects to view show question' do
        delete :destroy, id: answer
        expect(response).to redirect_to question_path answer.question
      end
    end
    context 'current user is not the owner of an answer' do
      malicious_case
      it 'fails to delete an answer' do
        answer
        expect{ delete :destroy, id: answer }.to_not change(Answer, :count)
      end
      it 'redirects to view show question' do
        delete :destroy, id: answer
        expect(response).to redirect_to question_path answer.question, notice: 'Restricted'
      end
    end
  end

end
