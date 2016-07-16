require_relative 'acceptance_helper'

feature 'user can registrate' do
  given(:user){ create :user }
  scenario 'unregistered user has ability to registrate' do
    visit root_path
    expect(page).to have_content 'Register' # /register/i
    click_on 'Register'
    expect(current_path).to eq new_user_registration_path
    fill_in 'Name', with: 'AntonioMontana'
    fill_in 'Email', with: 'email@gmail.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with:'12345678'
    click_on 'Sign up'
    expect(current_path).to eq root_path
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
  scenario "registered and logged in user whants to register once more" do
    sign_in user
    expect(page).to_not have_content 'Register'
  end
  context 'already registrated user or registration duplicate paremeters' do
    before do
      user
      visit root_path
      expect(page).to have_content 'Register'
      click_on 'Register'
      expect(current_path).to eq new_user_registration_path 
    end
    scenario "user try's to registrate himself with existing email or name 100% equality" do     
      fill_in 'Name', with: user.name
      fill_in 'Email', with: 'email@gmail.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with:'12345678'
      click_on 'Sign up'
      expect(current_path).to eq user_registration_path
      expect(page).to have_content /Name has already been taken./ 
    end
    scenario "user try's to registrate himself with existing email or name upcase" do       
      fill_in 'Name', with: user.name.upcase
      fill_in 'Email', with: 'email@gmail.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with:'12345678'
      click_on 'Sign up'
      expect(current_path).to eq user_registration_path
      expect(page).to have_content /Name has already been taken./   
    end
  end
end