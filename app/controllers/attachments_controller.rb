class AttachmentsController < ApplicationController
  def destroy
    @attachment = Attachment.find(params[:id])
    @res = @attachment.attachable_type.constantize
    unless current_user.author_of?(@res.find(@attachment.attachable_id))   
      redirect_to questions_path , notice: 'Restricted' and return
    end

    @attachment.destroy     
  end  
end