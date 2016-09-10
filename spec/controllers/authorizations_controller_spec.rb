require 'rails_helper'

RSpec.describe AuthorizationsController, type: :controller do

  describe "GET#new" do    

    it 'renders view new' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST#create" do  

    context 'with valid provider data' do      
      before do
        auth_hash = {
            provider: 'twitter',
            uid: '1234567',
            info: { name: 'SomeName' }
        }
        session['devise.provider_data'] = OmniAuth::AuthHash.new(auth_hash)
      end    

      it "sends email confirmation" do             
        expect{ post :create, authorization: { email: "user@email.com" } }.to change( ActionMailer::Base.deliveries, :count).by 1
      end
    end

    context 'user already exists' do
      before do
        auth_hash = {
            provider: 'twitter',
            uid: '1234567',
            info: { name: 'SomeName' }
        }
        session['devise.provider_data'] = OmniAuth::AuthHash.new(auth_hash)
      end
      let!(:user){ create :user, email: 'example@gmail.com', name: 'SomeName', confirmed_at: Time.now, password: '123123', password_confirmation: '123123'}

      it "should not create new User" do
        expect{ post :create, authorization: { email: "example@gmail.com" }}.to_not change(User, :count)
      end

      it "creates a new authorization for user" do
        expect{ post :create, authorization: { email: "example@gmail.com" }}.to change(user.authorizations, :count).by 1
      end

      it "should redirect to root_path" do
        post :create, authorization: { email: "example@gmail.com" }
        expect(response).to redirect_to root_path
      end
    end

    context "user does not exist" do
      before do
        auth_hash = {
            provider: 'twitter',
            uid: '1234567',
            info: { name: 'SomeName' }
        }
        session['devise.provider_data'] = OmniAuth::AuthHash.new(auth_hash)
      end

      it "should create a new user" do
        expect{ post :create, authorization: { email: "example@gmail.com" }}.to change(User, :count).by 1
      end

      it "should create an authorization for user" do
        post :create, authorization: { email: "example@gmail.com" }
        user = User.find_by_email("example@gmail.com")
        expect(user.authorizations.count).to eq 1
      end

      it "should create a propper authorization for user" do
        post :create, authorization: { email: "example@gmail.com" }
        user = User.find_by_email("example@gmail.com")
        expect(user.authorizations.first.uid).to eq "1234567"
      end

      it "should redirect to root path" do
        post :create, authorization: { email: "example@gmail.com" }
        expect(response).to redirect_to root_path
      end

    end

  end

end