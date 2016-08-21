class VotesController < ApplicationController    
  before_action :authenticate_user!   
  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy if current_user.author_of? @vote
    respond_to do |format|      
      format.json{ render json: { rating: @vote.votable.rating, votable: @vote.votable.id } }    
    end    
  end   
end