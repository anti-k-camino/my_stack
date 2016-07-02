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

    it('should populate array of questions') do
      questions = FactoryGirl.create_list(:question, 2)
      get :index
      expect(assigns(:questions)).to match_array([question1, question2])      
    end
    it('should render index view') do
      get :index
      expect(response).to render_template :index
    end
  end

end
