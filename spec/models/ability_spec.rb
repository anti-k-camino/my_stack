require 'rails_helper'

describe Ability  do
  subject(:ability){ Ability.new(user) }

  describe 'for guest' do
    let(:user){ nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user){ create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do

    let(:user){ create :user }
    let(:other_user){ create :user }
    let(:answer){ create :answer, user: user }
    let(:some_other_answer){ create :answer, user: other_user }
    let(:some_answer){ create :answer }    
    let(:question){ create :question, user: user }
    let(:other_question){ create :question, user: other_user }
    let(:best_answer){ create :answer, question: question, user: other_user }
    let(:best_other_answer){ create :answer, question: other_question }


    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, other_question }

    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, some_other_answer }    

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, other_question }

    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, some_other_answer }

    it { should be_able_to :destroy, create(:comment, body: 'Text',commentable: some_answer, user: user) }
    it { should_not be_able_to :destroy, create(:comment, body: 'Text', commentable: some_answer, user: other_user) }

    it { should_not be_able_to :upvote, answer }
    it { should be_able_to :upvote, some_other_answer }

    it { should_not be_able_to :upvote, question }
    it { should be_able_to :upvote, other_question }

    it { should_not be_able_to :downvote, answer }
    it { should be_able_to :downvote, some_other_answer }

    it { should_not be_able_to :downvote, question }
    it { should be_able_to :downvote, other_question }

    it { should be_able_to :destroy, create(:vote, votable: some_answer, vote_field: 1, user: user)}
    it { should_not be_able_to :destroy, create(:vote, votable: some_answer, vote_field: 1, user: other_user)}

    it { should be_able_to :destroy, create(:attachment, attachable: answer)}
    it { should_not be_able_to :destroy, create(:attachment, attachable: some_other_answer)}

    it { should be_able_to :best, best_answer }
    it { should_not be_able_to :best, best_other_answer }

    it { should be_able_to :me, user, user: user }
    it { should_not be_able_to :me, other_user, user: user }  

    context "with subscription" do
      let!(:question) { create :question }

      context "when user is not subscribed to question" do
        let(:subscription) { build :subscription, user_id: user.id, question: question }

        it { should     be_able_to :create,  subscription }
        it { should_not be_able_to :destroy, subscription, user_id: user.id }
      end

      context "when user subscirbed to question" do
        let!(:subscription) { create :subscription, user_id: user.id, question: question }

        it { should     be_able_to :destroy, subscription, user_id: user.id }
        it { should_not be_able_to :create,  subscription, user_id: user.id }
      end
    end       
    
  end

end