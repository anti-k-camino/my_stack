require "application_responder"


class ApplicationController < ActionController::Base  
  self.responder = ApplicationResponder
  respond_to :html

  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    #redirect_to root_url, alert: exception.message
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.json { head :ok, status: :forbidden }
      format.js   { head :ok, status: :forbidden }      
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