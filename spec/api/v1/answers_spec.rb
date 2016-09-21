require 'rails_helper'

describe 'Answers API'do 
  describe 'GET /index' do
    let!(:question){ create :question }
    let!(:answers){ create_list :answer, 2, question: question }
    let(:user){ create :user }
    let(:access_token){ create :access_token, resource_owner_id: user.id }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      before{ get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2)
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer contains #{attr}" do          
          expect(response.body).to be_json_eql(answers[1].send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end      
    end
  end

  describe 'POST #create' do    
     
    it_behaves_like 'API Authenticable Post'

    context 'authenticated user' do  
    
      context 'valid attributes' do
        let!(:user){ create :user }
        let!(:question){ create :question }
        let!(:access_token){ create :access_token, resource_owner_id: user.id }
        let(:request) do
          post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: access_token.token
        end      

        it 'responds with status 200' do
          request
          expect(response).to be_successful
        end

        it 'creates an answer' do
          expect{ request }.to change(question.answers, :count).by(1)
        end

        it 'creates answer with right body' do
          post "/api/v1/questions/#{question.id}/answers", answer: {body: 'sometext'}, format: :json, access_token: access_token.token
          expect(response.body).to be_json_eql('sometext'.to_json).at_path("body")                
        end      

        it 'changes user answers count' do
          expect{ request }.to change(user.answers, :count).by(1)
        end
      end

      context 'invalid attributes' do
        let!(:user){ create :user }
        let!(:access_token){ create :access_token, resource_owner_id: user.id }
        let!(:question){ create :question }
        let(:request) do
          post "/api/v1/questions/#{question.id}/answers", answer: { body: ''}, format: :json, access_token: access_token.token
        end    

        it 'should response with 422' do
          request
          expect(response.status).to eq 422
        end 

        it 'does not create an answer' do
          expect{ request }.to_not change(Answer, :count)
        end       

        it 'does not change user answers count' do
          expect{ request }.to_not change(user.answers, :count)
        end 
      end
     
    end
  end

  describe 'GET #show' do
    context 'unauthorized' do

      it 'returns 401 status if there is no access token' do
        get '/api/v1/answers/1', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access toke is invalid' do
        get '/api/v1/answers/1', format: :json, access_token: '123456789'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user){ create :user }
      let!(:access_token){ create :access_token }      
      let!(:answer){ create :answer}
      let!(:attachments){ create_list :attachment, 2, attachable: answer }      
      let!(:comments){ create_list(:comment, 2, commentable: answer, user: user, body: 'some text') }

      before{ get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status' do        
        expect(response).to be_successful
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer contains #{attr}" do          
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end     

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(2).at_path("comments")
        end        

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do                 
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

  def do_request(options = {})
    get "/api/v1/questions/#{question.id}/answers", {format: :json}.merge(options)
  end

  def do_post_request(options = {})    
    post "/api/v1/questions/1/answers", {answer: attributes_for(:answer),format: :json}.merge(options)
  end
end