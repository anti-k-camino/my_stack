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

    it 'build new attachment for answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end 
    
    it 'renders view show' do      
      expect(response).to render_template :show
    end
  end

  describe 'GET #upvote' do
    context 'Non authenticated user' do
      let!(:question){ create :question }      
      it 'does not create upvote' do
        expect{ get :upvote, id: question.id, format: :json }.to_not change(Vote, :count)
      end
      it 'responds with error' do
        get :upvote, id: question.id, format: :json        
        expect(JSON.parse(response.body)["error"]).to eq 'You need to sign in or sign up before continuing.'
      end
    end
    context 'Authenticated user' do
      sign_in_user      
      context 'Author of a resource' do
        let!(:question){ create :question, user: @user }
        it 'can not create upvote' do
          expect{ get :upvote, id: question.id, format: :json }.to_not change(Vote, :count)
        end

        it 'responds with error' do
          get :upvote, id: question.id, format: :json          
          expect(response.status).to eq 403
          expect(response.body).to eq "You are not authorized to perform this action."
        end

      end
      context 'Non author of a resource' do
        let!(:question){ create :question }

        it 'can not create upvote' do
          expect{ get :upvote, id: question.id, format: :json }.to change(question.votes, :count).by 1
        end

        it 'responds with propper json' do
          get :upvote, id: question.id, format: :json                         
          expect(JSON.parse(response.body)['vote']['votable_id']).to eq question.id
          expect(JSON.parse(response.body)['vote']['votable_type']).to eq 'Question'
          expect(JSON.parse(response.body)['vote']['vote_field']).to eq 1
        end

        it 'sets question rating' do
          get :upvote, id: question.id, format: :json
          expect(question.rating).to eq 1
        end

      end
    end
  end

  describe 'GET #downvote' do
    context 'Non authenticated user' do
      let!(:question){ create :question }      
      it 'does not create upvote' do
        expect{ get :downvote, id: question.id, format: :json }.to_not change(Vote, :count)
      end
      it 'responds with error' do
        get :downvote, id: question.id, format: :json        
        expect(JSON.parse(response.body)["error"]).to eq 'You need to sign in or sign up before continuing.'
      end
    end
    context 'Authenticated user' do
      sign_in_user      
      context 'Author of a resource' do
        let!(:question){ create :question, user: @user }
        it 'can not create upvote' do
          expect{ get :downvote, id: question.id, format: :json }.to_not change(Vote, :count)
        end


        it 'responds with error' do
          get :upvote, id: question.id, format: :json          
          expect(response.status).to eq 403
          expect(response.body).to eq "You are not authorized to perform this action."
        end
      end

      context 'Non author of a resource' do
        let!(:question){ create :question }

        it 'can not create upvote' do
          expect{ get :downvote, id: question.id, format: :json }.to change(question.votes, :count).by 1
        end

        it 'responds with propper json' do
          get :downvote, id: question.id, format: :json                         
          expect(JSON.parse(response.body)['vote']['votable_id']).to eq question.id
          expect(JSON.parse(response.body)['vote']['votable_type']).to eq 'Question'
          expect(JSON.parse(response.body)['vote']['vote_field']).to eq -1
        end

        it 'sets question rating' do
          get :downvote, id: question.id, format: :json
          expect(question.rating).to eq -1
        end

      end
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns Question to @question' do
      expect(assigns :question).to be_a_new Question      
    end

=begin
 it 'build new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end
=end


    it 'renders view new' do
      expect(response).to render_template :new
    end
  end



  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      let(:path) { '/questions' }
      let(:create_object) { post :create, question: attributes_for(:question) }
      let(:invalid) { post :create, question: attributes_for(:invalid_question) } 

      it_behaves_like "Publishable"

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
          patch :update, id: question, question: attributes_for(:question), format: :js
          expect(assigns :question).to eq question
        end 

        it 'changes question attributes' do
          patch :update, id: question, question: {title: 'NewTitle', body: 'NewBody'}, format: :js
          question.reload
          expect(question.title).to eq 'NewTitle'
          expect(question.body).to eq 'NewBody'
        end 

        it 'question has current user as an author' do
          patch :update, id: question, question: {title: 'NewTitle', body: 'NewBody'}, format: :js
          question.reload
          expect(question.user_id).to eq @user.id
        end

        it 'redirects to updated question' do
          patch :update, id: question, question: {title: 'NewTitle', body: 'NewBody'}, format: :js
          expect(response).to render_template :update
        end   
      end
      context 'with invalid attriutes' do 
        before do
          @title = question.title
          @body = question.body
          patch :update, id: question, question: { title: 'NewTitle', body: nil }, format: :js
          question.reload        
        end

        it 'does not change question attributes' do        
          expect(question.title).to eq @title
          expect(question.body).to eq @body
        end

        it 'renders view edit' do        
          expect(response).to render_template :update
        end
      end
    end
    context 'user is not author of a question' do
      malicious_case
      before do
        @body = question.body
        @title = question.title       
        patch :update, id: question, question: attributes_for(:question), format: :js
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
        expect(response).to render_template :show
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
