require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question){ create :question }
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
    before { get :show, id: question}
    it 'assigns requested question to @question' do      
      expect(assigns :question).to eq question
    end
    it 'renders view show' do      
      expect(response).to render_template :show
    end
  end


  describe 'GET #new' do
    before { get :new }
    it 'assigns Question to @question' do
      expect(assigns :question).to be_a_new Question
    end
    it 'renders view new' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do    
    before{ get :edit, id: question }

    it 'assigns required question to @question' do
      expect(assigns :question).to eq question
    end
    it 'renders view edit' do
      expect(response).to render_template :edit
    end
  end


end
