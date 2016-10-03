require 'rails_helper'

RSpec.describe Search do
  describe '.search_selection' do
    %w(Question Answer Comment User).each do |selection|
      it "call #{selection}" do
        expect(selection.constantize).to receive(:search).with('query')
        Search.search_selection('query', "#{selection}")
      end
    end
  end

  it 'call selection All' do
    expect(ThinkingSphinx).to receive(:search).with('query')
    Search.search_selection('query', 'All')
  end

  it 'call invalid selection' do
    expect(ThinkingSphinx).to_not receive(:search).with('query')
    Search.search_selection('query', 'invalid')
  end
end
