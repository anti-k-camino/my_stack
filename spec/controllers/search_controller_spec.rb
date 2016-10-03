require 'rails_helper'

RSpec.describe SearchController do
  describe 'GET #search' do
    let(:do_request){ get :search, { query: 'test', model: 'All' } }

    it_behaves_like 'Renderable templates', :search

    context 'search' do
      it 'should receive search' do
        expect(ThinkingSphinx).to receive(:search).with('test')
        do_request
      end
    end
  end
end