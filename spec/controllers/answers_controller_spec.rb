require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question){ create :question } 
  let(:answers){ create_list(:answer, 2) }

  describe 'GET #index' do    
    before{ get :index, question_id: question }
    it 'populates an array of answers to question' do      
      expect(assigns :answers).to match_array answers
    end
    it 'renders view index' do 
    end
  end



  describe 'GET #new' do
    before{ get :new, question_id: question }
    it 'assigns Answer to @answer' do
      expect(assigns :answer).to be_a_new Answer
    end
    it 'renders view new' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'valid parameters' do
      it 'saves new answer to db' do
        expect{ post :create, question_id: question, answer: attributes_for(:answer) }.to change(Answer, :count).by 1
      end
      it 'redirects to view question show' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(assigns :question)
      end
    end
    context 'invalid parameters' do
      it 'does not save answer to db' do
        expect{ post :create, question_id: question, answer: attributes_for(:invalid_answer) }.to_not change(question.answers, :count)      
      end
      it 'renders view new' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end
    end
  end



end
