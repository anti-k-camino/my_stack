require 'rails_helper'

describe 'Questions API'do 
  describe 'GET /index' do

    it_behaves_like "API Authenticable"
    
    
    context 'authorized' do
      let(:access_token){ create(:access_token) }
      let!(:questions){ create_list(:question, 2) }
      let(:question){ questions.first }
      let!(:answer){ create(:answer, question: question) }

      before{ get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question contains #{attr}" do          
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      it 'question object contains short title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('0/short_title')
      end

      context 'answers' do       

        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do          
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET #show' do
    it_behaves_like 'API Authenticable Show'
    context 'authorized' do
      let(:user){ create :user }
      let!(:access_token){ create :access_token }
      let!(:question){ create :question, user: user } 
      let!(:attachments){ create_list :attachment, 2, attachable: question }
      let!(:answers){ create_list(:answer, 2, question: question) }
      let!(:comments){ create_list(:comment, 2, commentable: question, user: user, body: 'some text') }

      before{ get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status' do        
        expect(response).to be_successful
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question contains #{attr}" do          
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end

      it 'question object contains short title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('short_title')
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(2).at_path("answers")
        end        

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do                   
            expect(response.body).to be_json_eql(answers[0].send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
          end
        end
      end 

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(2).at_path("comments")
        end        

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do 
          #NO UNDERSTANDING AT ALL!!!!!         
            expect(response.body).to be_json_eql(comments[0].send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(2).at_path("attachments")
        end        

        it 'contains url' do          
          expect(response.body).to be_json_eql(attachments[0].file.url.to_json).at_path('attachments/0/file/url')
        end
      end
     
    end
  end

  describe 'POST #create' do
    

    it_behaves_like 'API Authenticable Post'

    context 'authenticated user' do  

      context 'valid attributes' do
        let!(:user){ create :user }
        let!(:access_token){ create :access_token, resource_owner_id: user.id }
        let(:request) do
          post '/api/v1/questions', question: attributes_for(:question), format: :json, access_token: access_token.token
        end      

        it 'responds with status 200' do
          request
          expect(response).to be_successful
        end

        it 'creates a question' do
          expect{ request }.to change(Question, :count).by(1)
        end

        it 'creates question with right body' do
          post '/api/v1/questions', question: {body: 'sometext', title: 'sometitile'}, format: :json, access_token: access_token.token
          expect(response.body).to be_json_eql('sometext'.to_json).at_path("body")                
        end

        it 'creates question with right title' do
          post '/api/v1/questions', question: {body: 'sometext', title: 'sometitle'}, format: :json, access_token: access_token.token
          expect(response.body).to be_json_eql('sometitle'.to_json).at_path('title')                
        end

        it 'changes user questions count' do
          expect{ request }.to change(user.questions, :count).by(1)
        end
      end

      context 'invalid attributes' do
        let!(:user){ create :user }
        let!(:access_token){ create :access_token, resource_owner_id: user.id }
        let(:request) do
          post '/api/v1/questions', question: { body: 'somebody'}, format: :json, access_token: access_token.token
        end    

        it 'should response with 422' do
          request
          expect(response.status).to eq 422
        end 

        it 'does not create a question' do
          expect{ request }.to_not change(Question, :count)
        end       

        it 'does not change user questions count' do
          expect{ request }.to_not change(user.questions, :count)
        end 
      end      
    end
  end
  def do_request(options = {})
    get '/api/v1/questions', {format: :json}.merge(options)
  end

  def do_post_request(options = {})    
    post '/api/v1/questions', {question: attributes_for(:question),format: :json}.merge(options)
  end

  def do_show_request(options = {})
    get '/api/v1/questions/1', {format: :json}.merge(options)
  end
end