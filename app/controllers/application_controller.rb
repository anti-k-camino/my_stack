require "application_responder"


class ApplicationController < ActionController::Base  
  self.responder = ApplicationResponder
  respond_to :html

  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    #redirect_to root_url, alert: exception.message
    respond_to do |format|
      flash[:alert] = 'You are not authorized to perform this action.'
      format.html { redirect_to root_path }
      format.js { render file:"common/forbidden.js.erb", status: :forbidden }
      format.json { render json: flash[:alert], status: :forbidden}     
    end    
  end

  check_authorization unless: :devise_controller? 

  protected

  def configure_permitted_parameters
    added_attrs = [:name, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  
end