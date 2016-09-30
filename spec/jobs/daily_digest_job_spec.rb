=begin
require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  it 'sends daily digest' do
    expect(User).to receive(:send_daily_digest)
    DailyDigestJob.perform_now
  end
end
=end

require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let!(:users) { create_list :user, 2 }

  context "fresh questions exist" do
    let!(:questions) { create_list :question, 2, user: users.first, created_at: (Time.now - 24.hours) }

    it 'sends daily digest to all users' do
      users.each do |user|
        expect(DailyMailer).to receive(:digest).with(user, questions).and_call_original
      end
      described_class.perform_now
    end
  end

  context "there are no fresh quesitons" do
    it 'does not send daily digest' do
      expect(DailyMailer).not_to receive(:digest)
      described_class.perform_now
    end
  end
end
