class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_vote, only:[:destroy] 

  respond_to :json
  def destroy    
    @vote.destroy if current_user.author_of? @vote    
    respond_to do |format|      
      format.json{ render json: { rating: @vote.votable.rating, votable: @vote.votable.id } }    
    end  
  end 

  private
  def set_vote
    @vote = Vote.find(params[:id])
  end
end