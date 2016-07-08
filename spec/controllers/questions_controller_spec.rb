require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question){ create :question }
  describe 'GET #index' do
    let(:questions){ create_list(:question, 2) }
    before { get :index }
    it 'populates an array of questions' do
      expect(assigns :questions).to match_array questions
    end
    it 'renders view index' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do    
    before { get :show, id: question}
    it 'assigns requested question to @question' do      
      expect(assigns :question).to eq question
    end
    it 'renders view show' do      
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }
    it 'assigns Question to @question' do
      expect(assigns :question).to be_a_new Question
    end
    it 'renders view new' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user    
    before{ get :edit, id: question }
    it 'assigns required question to @question' do
      expect(assigns :question).to eq question
    end
    it 'renders view edit' do
      expect(response).to render_template :edit
    end
  end


  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new question to db' do
        expect{ post :create, question: attributes_for(:question)}.to change(Question, :count).by 1
      end
      it 'redirects to view show' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns :question)
      end
    end
    context 'with invalid attributes' do
      it 'does not save new question to db' do
        expect{ post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end 
      it 'renders view new' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    context 'with valid attributes' do
      it 'assigns question to @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns :question).to eq question
      end  
      it 'changes question attributes' do
        patch :update, id: question, question: {title: 'NewTitle', body: 'NewBody'}
        question.reload
        expect(question.title).to eq 'NewTitle'
        expect(question.body).to eq 'NewBody'
      end 
      it 'redirects to updated question' do
        patch :update, id: question, question: {title: 'NewTitle', body: 'NewBody'}
        expect(response).to redirect_to question
      end   
    end
    context 'with invalid attriutes' do 
      before do patch :update, id: question, question: { title: 'NewTitle', body: nil }
        @title = question.title
        @body = question.body
      end

      it 'does not change question attributes' do        
        expect(question.title).to eq @title
        expect(question.body).to eq @body
      end
      it 'renders view edit' do        
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    before{ question }
    it 'deletes question' do      
      expect{ delete :destroy, id: question }.to change(Question, :count).by -1
    end
    it 'redirects to view index' do
      delete :destroy, id: question
      expect(response).to redirect_to questions_path
    end
  end

end
