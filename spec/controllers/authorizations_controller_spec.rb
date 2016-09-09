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
        expect { post :create, authorization: { email: "user@email.com" } }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end
  end

end