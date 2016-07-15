require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  
  
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question){ create :question } 

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

    context 'current user is the author of a question' do
      let(:question){ create :question, user: @user } 

      before{ get :edit, id: question }

      it 'assigns required question to @question' do
        expect(assigns :question).to eq question
      end

      it 'renders view edit' do
        expect(response).to render_template :edit
      end
    end
    context 'curent user is not the author of a question' do
      malicious_case

      before{ get :edit, id: question } 

      it 'assigns required question to @question' do
        expect(assigns :question).to eq question
      end

      it 'renders view index' do
        expect(response).to render_template :show , notice:'Restricted'
      end
    end
  end


  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do      
      it 'user  has this question as the author' do
        post :create, question: attributes_for(:question)
        expect(assigns(:question).user_id).to eq @user.id
      end

      it 'increments user questions count' do
        expect{ post :create, question: attributes_for(:question) }.to change(@user.questions, :count).by 1
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
    context 'user is author of a question' do
      let(:question){ create :question, user: @user}
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
        it 'question has current user as an author' do
          patch :update, id: question, question: {title: 'NewTitle', body: 'NewBody'}
          question.reload
          expect(question.user_id).to eq @user.id
        end
        it 'redirects to updated question' do
          patch :update, id: question, question: {title: 'NewTitle', body: 'NewBody'}
          expect(response).to redirect_to question
        end   
      end
      context 'with invalid attriutes' do 
        before do
          @title = question.title
          @body = question.body
          patch :update, id: question, question: { title: 'NewTitle', body: nil }
          question.reload        
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
    context 'user is not author of a question' do
      malicious_case
      before do
        @body = question.body
        @title = question.title       
        patch :update, id: question, question: attributes_for(:question)
        question.reload       
      end      
      it 'does not modify @question' do              
        expect(question.title).to eq @title
        expect(question.body).to eq @body        
      end
      it 'does not changes the author' do
        expect(question.user_id).to_not eq @user.id
      end
      it 'renders view show' do        
        expect(response).to render_template :show, id: question, notice: 'Restricted'
      end
    end
  end

  describe 'DELETE #destroy' do 
    sign_in_user 
    
    context 'current user is the author of a question' do 
      let(:question){ create :question, user: @user }
      
      it 'deletes question' do
        question      
        expect{ delete :destroy, id: question }.to change(@user.questions, :count).by -1 #if subject.current_user.permission? question
      end
      it 'redirects to view index' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end
    context 'current user is not the owner of a question' do
      malicious_case
      it 'fails to delete a question' do
        question
        expect{ delete :destroy, id: question }.to_not change(Question, :count)
      end
      it 'renders view show' do
        delete :destroy, id: question
        expect(response).to render_template :show, id: question, notice: 'Restricted'
      end
    end
  end

end
