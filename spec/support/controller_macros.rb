module ControllerMacros
  def sign_in_user
    before do
      @user = create(:user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
  end

  def malicious_case
    let(:malicious_case){ create :user }
    let(:question){ create :question, user: malicious_case }
  end
end