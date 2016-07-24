require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question){ create :question } 
  let(:question_with_answers){ create :question_with_answers } 
  let(:answer){ create :answer }  

  describe 'POST #create' do
    sign_in_user

    context 'valid parameters' do      
      it 'saves new answer to db' do
        expect{ post :create,  answer:{ body:'TestBody', user: @user }, question_id: question, format: :js }.to change(question.answers, :count).by 1
      end

      it 'changes author user answers' do
        expect{ post :create, question_id: question, answer:{ body:'TestBody', user: @user }, format: :js }.to change(@user.answers, :count).by 1
      end

      it 'renders view question show' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response.body).to be_blank
      end
    end

    context 'invalid parameters' do
      it 'does not save answer to db' do
        expect{ post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)      
      end

      it 'renders view question#show' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end
    end
  end
  describe 'PATCH #update' do 

    context 'Non-authenticated user try to edit answer' do
      let(:answer){ create :answer, question: question }

      it 'fails to update answer' do
        ans = (assigns :answer)
        patch :update, id: answer, answer:{ body: 'Malicious try'}
        answer.reload        
        expect(assigns :answer).to eq ans
      end
    end

    context 'Authenticated user' do
      sign_in_user      
      let!(:answer){ create :answer, question: question, user: @user }

      describe 'try to edit own answer with valid attributes' do        
        it 'assignes question to question' do
          patch :update, id: answer, answer:(attributes_for(:answer)), format: :js
          expect(assigns :answer).to eq answer
        end

        it 'it checks if answer belongs to user' do
          patch :update, id: answer, answer: { body: 'TestAnswerBody', user: @user }, format: :js
          answer.reload           
          expect(@user.answers.last.body).to eq answer.body
        end

        it 'does not create some new answers to a question' do
          expect{ patch :update, id: answer, answer: { body: 'TestAnswerBody' }, format: :js }.to_not change(question.answers, :count)
        end  

        it 'changes answer attributes' do
          patch :update, id: answer, answer: { body: 'TestAnswerBody', user: @user }, format: :js
          answer.reload
          expect(assigns :answer).to eq answer
        end

        it 'renders update' do
          patch :update, id: answer, answer: { body: 'TestAnswerBody', user: @user }, format: :js 
          expect(response).to render_template :update
        end 
      end

      describe 'with invalid attriutes' do 
        before do
          patch :update, id: answer, answer: { body: nil }, format: :js          
          @body = answer.body
        end

        it 'does not change answer attributes' do           
          expect(answer.body).to eq @body
        end

        it 'renders update' do                
          expect(response).to render_template :update
        end              
      end

      describe 'try to edit someone else answer' do
        malicious_case
        before do
          patch :update, id: answer, answer: attributes_for(:answer), format: :js
          @body = answer.body
        end

        it 'does not modify @answer' do        
          expect(answer.body).to eq @body        
        end

        it 'redirects to view show question answers' do        
          expect(response).to render_template :update
        end
      end
    end    
  end

  describe 'PATCH#best' do
     
    context 'Non authenticated user' do
      let(:question){ create :question }
      let!(:answer){ create :vote_answer, question: question }
      let!(:best_answer){ create :vote_answer, question: question, best: true}        
      before do
        patch :best, id: answer, format: :js
      end

      it 'changes answer best attribute to true' do          
        answer.reload
        expect(answer.best).to_not be_truthy
      end

      it 'changes other answers attribute to false' do          
        best_answer.reload
        expect(best_answer.best).to_not be_falsy
      end
    end

    context 'Authenticated user' do          
     
      context 'Author of a question' do
        sign_in_user
        let!(:sample_question){ create :question, user: @user}        
        let!(:best_answer){ create :vote_answer, question: sample_question, best: true}
        let!(:answer){ create :vote_answer, question: sample_question }

        before do
          patch :best, id: answer, format: :js
        end

        it 'changes answer best attribute to true' do          
          answer.reload
          expect(answer.best).to be_truthy
        end

        it 'changes other answers attribute to false' do          
          best_answer.reload
          expect(best_answer.best).to be_falsy
        end
      end

      context 'non author of a question' do 
        malicious_case       
        let!(:non_author_question){ create :question }
        let!(:non_answer){ create :vote_answer, question: non_author_question }
        let!(:non_best_answer){ create :vote_answer, question: non_author_question, best: true}
         
        before do
          patch :best, id: non_answer, format: :js
        end

        it 'does not change answer.best attribute to true' do          
          non_answer.reload
          expect(non_answer.best).to be_falsy
        end

        it 'does not changes other answers attribute to false' do          
          non_best_answer.reload
          expect(non_best_answer.best).to be_truthy
        end
      end
    end
    context 'it renders template best' do
      sign_in_user
      let!(:question_render){ create :question, user: @user }
      let!(:answer_render){ create :answer, question: question_render }
      
      it 'renders template best' do 
        patch :best, id: answer_render, user: @user, format: :js
        expect(response).to render_template :best
      end
    end
   
  end

  describe 'DELETE #destroy' do
    sign_in_user    
    let(:answer){ create :answer, user: @user } 
    let(:foreign_answer){ create :answer }   
    context 'current user is the author of an answer' do 

      it 'deletes answer' do
        answer             
        expect{ delete :destroy, id: answer, format: :js }.to change(@user.answers, :count).by -1        
      end

      it 'redirects to view show question' do
        delete :destroy, id: answer, format: :js
        expect(response).to render_template :destroy
      end
    end
    context 'current user is not the owner of an answer' do    
      
      it 'fails to delete an answer' do
        foreign_answer
        expect{ delete :destroy, id: answer, format: :js }.to_not change(Answer, :count)
      end

      it 'redirects to view show question' do
        delete :destroy, id: foreign_answer, format: :js
        expect(response).to redirect_to foreign_answer.question
      end
    end
  end  
end
