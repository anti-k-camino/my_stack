class AuthorizationsController < ApplicationController
  def new
    @authorization = Authorization.new
  end
  def create
    @user = User.find_by(email: params[:authorization][:email])
    @auth = session['devise.provider_data']
    if @user        
      @user.create_authorization!(@auth)
    else 
      User.create_self_and_authorization!(@auth, params[:authorization][:email]) 
      flash[:notice] = "Confirmation email was sent!"      
    end
    redirect_to root_path
  end
end