class Api::V1::ProfilesController < Api::V1::BaseController 
  
  authorize_resource class: User  

  api :GET, '/profiles', "This is index for all registered users except current user" 
  def index    
    render json: User.where.not(id: current_resource_owner.id)    
  end 

  api :GET, '/profiles/me', "This is current user profile's data"
  def me    
    render json: current_resource_owner         
  end 
end