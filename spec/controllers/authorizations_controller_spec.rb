require 'rails_helper'

RSpec.describe AuthorizationsController, type: :controller do

  describe "GET#new" do    

    it 'renders view new' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST#create" do
    #context "user with such already email exists" do
      #let!(:authorization){ create :authorization, uid: '1234567890', provider: 'twitter' }

    #end
=begin
    context 'with valid provider data' do
      before do
        auth_hash = {
            provider: 'twitter',
            uid: '1234567',
            info: { name: 'SomeName' }
        }
        session['devise.provider_data'] = OmniAuth::AuthHash.new(auth_hash)
      end
      #let!(:user){ create :user, email: "user@email.com", name: 'name', password: '123123', confirmed_at: (Time.now -10) }

      it "sends email confirmation" do
        post :create, authorization: { email: "user@email.com" } 
        p "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"
        p ActionMailer::Base.deliveries.count
        expect(ActionMailer::Base.deliveries.count).to eq 1
      end
    end
=end
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
    end

  end

end