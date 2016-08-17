class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only:[:create]
  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.json{ render json:{ comment: @comment, type: @comment.commentable_type.underscore, user_name: @comment.user.name } }
      else        
        format.json{ render json:{ errors: @comment.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @question = @comment.commentable
    @comment.destroy
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end
  def set_commentable
    id = params.keys.detect{ |key| key.to_s =~ /(question|answer)_id/ }
    @commentable = $1.classify.constantize.find(params[id])
  end
end
