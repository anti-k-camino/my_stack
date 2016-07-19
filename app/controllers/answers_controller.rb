class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, except:[:update, :destroy]
  before_action :set_answer, only:[:update, :destroy]
  before_action :not_author?, only:[:update, :destroy]



  def create    
    @answer = @question.answers.new(answer_params)    
    @answer.user = current_user   
    @answer.save      
  end

  def update    
    @answer.update(answer_params);   
  end

  def destroy  
    @question = @answer.question      
    @answer.destroy
    redirect_to @question, notice: 'Answer successfully destroyed.'    
  end

  private
  def not_author?
    unless current_user.author_of?(@answer)    
      redirect_to @answer.question, notice: 'Restricted'
    end
  end

  def set_question
    @question = Question.find params[:question_id]
  end 

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
