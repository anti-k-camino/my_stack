module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only:[:upvote, :downvote]    
  end

  def downvote    
    @vote = @votable.downvote(current_user)
    rendering
  end

  def upvote    
    @vote = @votable.upvote(current_user)    
    rendering
  end

  private

  def model_klass
    controller_name.classify.constantize
  end
  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def rendering
    if @vote.vote_permitted?     
      @vote.errors[:base] << "Author can not vote for his resource"
      render json: @vote.errors.full_messages, status: 403 and return 
    end
    respond_to do |format|
      if @vote.save
        format.json{ render json: { vote: @vote, rating: @votable.rating } }
      else
        format.json{ render json: @vote.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end
end