require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do 
  let!(:question) { create :question }
  context 'Authenticated' do
    sign_in_user
    describe 'POST #create' do
      it 'creates subscription in DB' do
        expect { post :create, user_id: @user.id,  question_id: question, format: :js }
          .to change(@user.subscriptions, :count).by(1)
          .and change(question.subscriptions, :count).by(1)
      end
    end

    describe 'DELETE #destroy' do
      before { create :subscription, user_id: @user.id, question: question }

      it 'destroys subscription in DB' do
        expect { delete :destroy, question_id: question, format: :js }
          .to change(@user.subscriptions, :count).by(-1)
          .and change(question.subscriptions, :count).by(-1)
      end
    end
  end

  context 'User is not signed in', :unauth do
    describe 'POST #create' do
      it 'does not create subscription in DB' do
        expect { post :create, question_id: question, format: :js }
          .not_to change(Subscription, :count)
      end
    end

    describe 'DELETE #destroy' do
      let!(:user){ create :user }
      before { create :subscription, user_id: user.id, question: question }

      it 'does not destroy subscription in DB' do
        expect { delete :destroy, question_id: question, format: :js }
          .not_to change(Subscription, :count)
      end
    end
  end

end
