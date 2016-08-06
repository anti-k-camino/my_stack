class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, except:[:update, :destroy, :best, :upvote, :downvote]
  before_action :set_answer, only:[:update, :destroy, :best, :upvote, :downvote]
  before_action :get_question, only:[:best, :destroy]
  before_action :not_author?, except:[:create, :best, :upvote, :downvote]

  def create    
    @answer = @question.answers.new(answer_params)    
    @answer.user = current_user       
    @answer.save              
  end

  def update    
    @answer.update(answer_params);   
  end

  def best
    not_author?(@answer.question)    
    @answer.the_best!
  end

  def destroy           
    @answer.destroy        
  end
  
  def upvote     
    @vote = Vote.new(votable_id: @answer.id, user_id: current_user.id, votable_type: 'Answer', vote_field: 1)    
    if @vote.check_vote_permission?     
      @vote.errors[:base] << "Author can not vote for his resource"
      render json: @vote.errors.full_messages, status: 403 and return 
    end
    respond_to do |format|
      if @vote.save
        format.json{ render json: { vote: @vote, rating: @answer.rating } }
      else
        format.json{ render json: @vote.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def downvote     
    @vote = Vote.new(votable_id: @answer.id, user_id: current_user.id, votable_type: 'Answer', vote_field: -1)
    if @vote.check_vote_permission?     
      @vote.errors[:base] << "Author can not vote for his resource"
      render json: @vote.errors.full_messages, status: 403 and return 
    end
    @vote.errors[:base] << "Author can not vote for his resource" if @vote.user == @vote.votable.user
    respond_to do |format|
      if @vote.save
        format.json{ render json: { vote: @vote, rating: @answer.rating } }
      else
        format.json{ render json: @vote.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end 

  private
  def not_author?(obj = @answer)
    unless current_user.author_of?(obj)    
      redirect_to @answer.question, notice: 'Restricted'
    end
  end

  def get_question
    @question = @answer.question
  end

  def set_question
    @question = Question.find params[:question_id]
  end 

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :type, :_destroy])
  end
end
