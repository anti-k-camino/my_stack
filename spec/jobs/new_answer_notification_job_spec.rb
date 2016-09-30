require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let!(:question) { create :question }
  let!(:user){ create :user }

  before { create :subscription, user_id: user.id, question: question }

  context "new answer created" do
    let(:answer) { create :answer, question: question }

    it 'sends notifications to subscribers' do
      expect(NewAnswerMailer).to receive(:notification)
        .with(question.user, answer).and_call_original

      expect(NewAnswerMailer).to receive(:notification)
        .with(user, answer).and_call_original

      described_class.perform_now(answer)
    end
  end

  context 'Creation answer' do
    
    it 'calls' do
      @answer = Answer.new(attributes_for(:answer, question_id: question.id, user_id: 1))

      expect(NewAnswerMailer).to receive(:notification)
        .with(question.user, @answer).and_call_original

      expect(NewAnswerMailer).to receive(:notification)
        .with(user, @answer).and_call_original 

      @answer.save!     
    end
  end

  context "new answer was not created" do
    it 'does not send notifications to subscribers' do
      expect(NewAnswerMailer).not_to receive :notification
      described_class.perform_now(nil)
    end
  end
end
