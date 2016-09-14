class Api::V1::ProfilesController < Api::V1::BaseController 
  
  authorize_resource class: User
  respond_to :json

  api :GET, '/profiles', "This is index for all registered users except current user" 
  def index    
    render json: User.where.not(id: current_resource_owner.id)    
  end 

  api :GET, '/profiles/me', "This is current user profile's data"
  def me    
    render json: current_resource_owner         
  end

  protected
  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end