class AuthorizationsController < ApplicationController
  def new
    @authorization = Authorization.new
  end
  def create
    @user = User.where(email: params[:authorization][:email]).first
    @auth = session['devise.provider_data']
    if @user         
      @user.authorizations.create!(provider: @auth['provider'], uid: @auth['uid'])
      @user.update(confirmed_at: nil)     
      @user.send_confirmation_instructions     
    else 
      pass = Devise.friendly_token[0, 20]             
      @user = User.create!(name: @auth['info']['name'], email: params[:authorization][:email], password: pass, password_confirmation: pass)     
      @user.authorizations.create!(provider: @auth['provider'], uid: @auth['uid'])       
    end
    redirect_to root_path
  end
end