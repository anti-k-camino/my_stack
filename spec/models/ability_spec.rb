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
    let(:some_answer){ create :answer }
    let(:some_other_answer){ create :answer, user: other_user }
    let(:question){ create :question, user: user }
    let(:other_question){ create :question, user: other_user }
    let(:best_answer){ create :answer, question: question, user: other_user }
    let(:best_other_answer){ create :answer, question: other_question }


    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, user: user) }
    it { should_not be_able_to :update, create(:question, user: other_user) }

    it { should be_able_to :update, create(:answer, user: user) }
    it { should_not be_able_to :update, create(:answer, user: other_user) }    

    it { should be_able_to :destroy, create(:question, user: user) }
    it { should_not be_able_to :destroy, create(:question, user: other_user) }

    it { should be_able_to :destroy, create(:answer, user: user) }
    it { should_not be_able_to :destroy, create(:answer, user: other_user) }

    it { should be_able_to :destroy, create(:comment, body: 'Text',commentable: some_answer, user: user) }
    it { should_not be_able_to :destroy, create(:comment, body: 'Text', commentable: some_answer, user: other_user) }

    it { should_not be_able_to :upvote, create(:answer, user: user) }
    it { should be_able_to :upvote, create(:answer, user: other_user) }

    it { should_not be_able_to :upvote, create(:question, user: user) }
    it { should be_able_to :upvote, create(:question, user: other_user) }

    it { should_not be_able_to :downvote, create(:answer, user: user) }
    it { should be_able_to :downvote, create(:answer, user: other_user) }

    it { should_not be_able_to :downvote, create(:question, user: user) }
    it { should be_able_to :downvote, create(:question, user: other_user) }

    it { should be_able_to :destroy, create(:vote, votable: some_answer, vote_field: 1, user: user)}
    it { should_not be_able_to :destroy, create(:vote, votable: some_answer, vote_field: 1, user: other_user)}

    it { should be_able_to :destroy, create(:attachment, attachable: answer)}
    it { should_not be_able_to :destroy, create(:attachment, attachable: some_other_answer)}

    it { should be_able_to :best!, best_answer }
    it { should_not be_able_to :best!, best_other_answer }


  end
end