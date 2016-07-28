class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  def destroy
    @attachment = Attachment.find(params[:id])    
    unless current_user.author_of?(@attachment.attachable)   
      redirect_to questions_path , notice: 'Restricted' and return
    end    
    @attachment.destroy     
  end  
end