class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attachment, only:[:destroy]
  before_action :check_permission, only:[:destroy]
  respond_to :js

  authorize_resource
  
  def destroy     
    respond_with @attachment.destroy     
  end  

  private
  def set_attachment
    @attachment = Attachment.find(params[:id])    
  end

  def check_permission
    unless current_user.author_of?(@attachment.attachable)   
      redirect_to questions_path , notice: 'Restricted' and return
    end
  end
end