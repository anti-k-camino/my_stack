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

  describe 'GET #edit' do
    sign_in_user
    before{ get :edit, id: answer}
    it 'assigns required answer to @answer' do
      expect(assigns :answer).to eq answer
    end
    it 'renders view edit' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'valid parameters' do
      it 'saves new answer to db' do
        expect{ post :create, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count).by 1
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
    context 'valid parameters' do
      it 'assigns answer to @answer' do
        patch :update, id: answer, answer: attributes_for(:answer)
        expect(assigns :answer).to eq answer
      end
      it 'changes answer attributes' do
        patch :update, id: answer, answer: { body: 'NewBody' }
        answer.reload
        expect(answer.body).to eq 'NewBody' 
      end
      it 'redirects to question' do
        patch :update, id: answer, answer: { body: 'NewBody' }
        expect(response).to redirect_to question_path answer.question , notice:'Your answer successfully apdated'
      end
    end
    context 'invalid parameters' do
    end
  end



end
