class AnswersController < ApplicationController
  before_action :authenticate_user!, except:[:index, :show]
  before_action :set_question, except:[:show, :edit, :update, :destroy]
  before_action :set_answer, only:[:show, :edit, :update, :destroy]
  before_action :not_author?, only:[:edit, :update, :destroy]
  
  def index
    @answers = @question.answers
  end

  def edit    
  end

  def create    
=begin
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
=end

    @answer = @question.answers.create(answer_params)
    
=begin
   if @answer.save
      redirect_to @question, notice:'Your answer successfully added.'
    else      
      
    end
=end

  end

  def update     
    if @answer.update(answer_params)
      redirect_to @answer.question, notice:'Your answer successfully updated'
    else
      render :edit
    end
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
    params.require(:answer).permit(:body).merge(user_id: current_user.id)
  end
end
