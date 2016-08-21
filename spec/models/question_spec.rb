require 'rails_helper'

RSpec.describe Question, type: :model do  

  it { should validate_presence_of :title }              
  it { should validate_presence_of :body } 
  it { should validate_presence_of :user_id }
  it { should have_db_index :title }
  it { should have_db_index :user_id }
  it { should have_many(:answers).dependent :destroy }
  it { should have_many(:votes).dependent :destroy }
  it { should have_many(:users) }
  it { should have_many(:attachments).dependent :destroy }
  it { should accept_nested_attributes_for :attachments }

  
  describe 'user_voted?' do 
    let!(:user){ create :user } 
    let!(:sample_user){ create :user }  
    let!(:question){ create :question }
    let!(:vote){ create :vote, user: user, votable: question, vote_field: 1}   
  
    it 'user different from resource user is accapteble' do
      expect(question.user_voted?(sample_user)).to be_falsy
    end

    it 'user similar to resource user is accapteble' do
      expect(question.user_voted?(user)).to be_truthy
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
end
