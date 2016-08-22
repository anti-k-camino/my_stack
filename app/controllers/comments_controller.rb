class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only:[:destroy]
  before_action :set_commentable, only:[:create]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.json do
          PrivatePub.publish_to "/comments", comment_res: { comment: @comment.to_json, user: current_user.to_json, type: @comment.commentable_type.downcase, type_id: @commentable.id  }
          render :nothing => true          
        end
      else
        format.js
      end
    end
  end

  def destroy    
    if current_user.author_of? @comment         
      @comment.destroy 
    end
  end

  private
  def set_comment
    @comment = Comment.find(params[:id])
  end
  def set_commentable
    id = params.keys.detect{ |key| key.to_s =~ /(question|answer)_id/ }
    @commentable = $1.classify.constantize.find(params[id])
  end
  def comment_params
    params.require(:comment).permit(:body)
  end
end
