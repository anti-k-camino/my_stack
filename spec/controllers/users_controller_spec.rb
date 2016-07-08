require 'rails_helper'

RSpec.describe UsersController, type: :controller do 

  let(:user){ create(:user) }
  describe 'GET #index' do
    let(:users){ create_list(:user, 2) }
    before{ get :index }  

    it 'populates an array of users' do
      expect(assigns :users).to match_array users
    end

    it 'redirects to view index' do
      expect(response).to render_template :index
    end

  end 
  describe 'GET #show' do
    before{ get :show, id: user }
    it 'assigns required user to @user' do
      expect(assigns :user).to eq user
    end
    it 'renders view show' do
      expect(response).to render_template :show
    end
  end
end
