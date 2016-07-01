require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
=begin
describe 'GET #index' do
    it 'populates an array of all questions' do
      question1 = FactoryGirl.create(:question)
      question2 = FactoryGirl.create(:question)

      get :index

      expect(assigns(:questions)).to match_array([question1, question2])
    end

    it 'renders index view' do
      get :index
      expect(response).to render_template :index
    end

  end
=end
  describe 'GET #index' do
    it('should populate array of all questions') do
      question1 = FactoryGirl.create(:question)
      question2 = FactoryGirl.create(:question)

      get :index

      expect(assign(:questions)).to match_array([question1, question2])
    end
    it ('should render view index') do
      get :index

      expect(response).to render_template :index
    end 
  end

end
