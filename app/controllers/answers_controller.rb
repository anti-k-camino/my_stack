class AnswersController < BaseController
  before_action :set_question, except:[:show, :edit, :update, :destroy]
  before_action :set_answer, only:[:show, :edit, :update, :destroy]
  def index
    @answers = @question.answers
  end
  def show
  end
  def new
    @answer = Answer.new
  end
  def edit
  end
  def create    
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to @question, notice:'Your answer successfully added.'
    else
      render :new
    end
  end
  def update
    if @answer.update! answer_params
      redirect_to question_path @answer.question, notice:'Your answer successfully apdated'
    else
      render :edit
    end
  end
  private
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
