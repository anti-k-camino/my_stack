require 'rails_helper'

describe 'Login to API' do
  subject {page}
  context 'Authorized' do
    context 'user with admin abilities' do
      let!(:admin){ create :user, admin: true }
      let!(:access_token_admin){ create :access_token, resource_owner_id: admin.id }
      it 'admin user should have access to applications manager' do
        get '/oauth/applications'#, format: :json, access_token: access_token_admin
        #expect(response.status).to eq 302
        #expect(page.path).to eq '/oauth/applications' 
        expect(current_path).to eq '/oauth/applications'    
      end
    end
    context 'ordinary user' do
    end
  end

end