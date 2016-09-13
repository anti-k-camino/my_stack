class Api::V1::ProfilesController < Api::V1::BaseController 
  #skip_before_action :authenticate_user!

  before_action :doorkeeper_authorize! 
  #skip_authorization_check 
  authorize_resource class: User

  def index
    respond_to do|format|
      format.json { render json: User.where.not(id: current_resource_owner.id) }
    end
  end 

  def me
    respond_to do |format|
      format.json { render json: current_resource_owner }
    end    
  end

  protected
  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end