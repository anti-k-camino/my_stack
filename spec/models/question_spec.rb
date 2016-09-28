require 'rails_helper'

RSpec.describe Question, type: :model do 
  
  
  it_behaves_like "User Ownerable"
  it_behaves_like "Ownerable" 

  it { should validate_presence_of :title }              
 
  
  it { should have_db_index :title }
  
  it { should have_many(:answers).dependent :destroy }
  it { should have_many(:votes).dependent :destroy }
  it { should have_many(:subscriptions).dependent :destroy }
  it { should have_many(:users) } 
  

  describe 'user_voted?' do
    it_behaves_like 'User Votable' do
      subject { build(:question) }
    end
  end

  describe 'upvote' do
    let(:user){ create :user }
    let(:another_user){ create :user }
    let(:question){ create :question, user: another_user }

    context 'voter is a author of a question' do      
      it 'can not upvote a question' do        
        expect(question.upvote(another_user).valid?).to be_falsy
      end
    end

    context 'voter is not the author of a question' do
      it 'can upvote a question' do        
        expect(question.upvote(user).valid?).to be_truthy
      end
    end
  end
  
  describe 'downvote' do
    let(:user){ create :user }
    let(:another_user){ create :user }
    let(:question){ create :question, user: another_user }

    context 'voter is a author of a question' do      
      it 'can not downvote a question' do        
        expect(question.downvote(another_user).valid?).to be_falsy
      end
    end

    context 'voter is not the author of a question' do
      it 'can downvote a question' do        
        expect(question.downvote(user).valid?).to be_truthy
      end
    end
  end

  describe '.subscribe_author' do
    let(:question) { create :question }

    it 'is called after creating' do
      expect(Subscription.where(user: question.user, question: question)).to exist
    end
  end
end
