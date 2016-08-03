class VotesController < ApplicationController
  before_action :authenticate_user!   
  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy
    respond_to do |format|
      if @vote.errors.any?        
        format.json{ render json: @vote.errors.full_messages, status: :unprocessable_entity }
      else
        format.json{ render json: @vote.votable.rating }
      end
    end    
  end  
end