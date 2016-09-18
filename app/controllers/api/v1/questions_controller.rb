class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource  
  before_action :set_question, only:[:show] 

  api :GET, '/questions', 'This is index for all questions'
  def index
    @questions = Question.all
    render json: @questions  
  end

  api :GET, '/questions/id', 'This renders question by id'
  def show
    render json:@question
  end

  api :POST, '/questions', 'This creates a new question'
  def create
    @question = current_resource_owner.questions.new(question_params)
    if @question.save
      render json: @question, status: 200
    else
      render json:{ errors: @question.errors.full_messages }, status: 422
    end
  end
  
  protected
  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end