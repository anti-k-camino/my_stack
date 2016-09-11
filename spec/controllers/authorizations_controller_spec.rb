require 'rails_helper'

RSpec.describe AuthorizationsController, type: :controller do

  describe "GET#new" do    

    it 'renders view new' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST#create" do
    let!(:auth){ OmniAuth::AuthHash.new(provider:'twitter', uid: '654321', info: { name: 'Antonio Montana'}) }         
    before do      
      session['devise.provider_data'] = auth 
    end
    context 'with valid provider data and existing email' do
      let!(:user){ create :user , email: "user@email.com" }      

      it "sends email confirmation" do             
        expect{ post :create, authorization: { email: "user@email.com" } }.to change( ActionMailer::Base.deliveries, :count).by 1
      end

      it "does not create a new user" do
        expect{ post :create, authorization: { email: "user@email.com" } }.to_not change(User, :count)
      end

      it "creates an association for a user" do
        expect{ post :create, authorization: { email: "user@email.com" } }.to change(user.authorizations, :count)
      end

      it "should redirect to root path" do
        post :create, authorization: { email: "example@gmail.com" }
        expect(response).to redirect_to root_path
      end
    end

    context 'valid data and non-existing  user' do      

      it "should create a new User" do
        expect{ post :create, authorization: { email: 'example@gmail.com' } }.to change(User, :count).by(1)
      end

      it "creates a new authorization for user" do
        post :create, authorization: { email: "example@gmail.com" }
        expect(User.last.authorizations.count).to eq 1
      end

      it "creates an authorization with propper attributes" do
        post :create, authorization: { email: "example@gmail.com" }
        expect(User.last.authorizations.first.provider).to eq auth['provider']
        expect(User.last.authorizations.first.uid).to eq auth['uid']
      end

      it "should redirect to root_path" do
        post :create, authorization: { email: "example@gmail.com" }
        expect(response).to redirect_to root_path
      end
    end
  end

end