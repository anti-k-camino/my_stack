class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.callback_for(provider)
    class_eval %{
      def #{provider}
        auth  = request.env['omniauth.auth']
        @user = User.find_for_oauth(auth)
        if @user && @user.persisted? && @user.authorizations.find_by(uid: auth.uid)
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
        else
          session["devise.provider_data"] = auth.except("extra")
          redirect_to new_authorization_path
        end
      end
    }
  end

  [:facebook, :twitter].each { |provider| callback_for provider }
end