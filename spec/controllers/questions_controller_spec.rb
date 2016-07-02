require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:questions){ create_list(:question, 2) }
    before { get :index }
    it 'populates an array of questions' do
      expect(assigns :questions).to match_array questions
    end
    it 'renders view index' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question){ create :question }
    before { get :show, id: question}
    it 'assigns requested question to @question' do      
      expect(assigns :question).to eq question
    end
    it 'renders view show' do      
      expect(response).to render_template :show
    end
  end
end
