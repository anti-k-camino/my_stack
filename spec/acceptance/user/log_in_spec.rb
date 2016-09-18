require_relative '../acceptance_helper'

feature 'Login to API' do
  
  context 'Admin' do
    given!(:admin){ create :user, admin: true }  
    
    scenario 'user should  not have access to applications manager' do      
      sign_in admin       
      visit '/oauth/applications'      
      expect(current_path).to eq '/oauth/applications'
    end
  end

  context 'Registered ordinary' do
    given!(:user){ create :user }
    
    scenario 'user should  not have access to applications manager' do
      sign_in user
      visit '/oauth/applications'          
      expect(current_path).to eq root_path      
    end
  end

  context 'Unregistered' do
    given!(:user){ create :user }
    
    scenario 'user should be redirected to sign in path' do
      
      visit '/oauth/applications'          
      expect(current_path).to eq new_user_session_path      
    end
  end
end