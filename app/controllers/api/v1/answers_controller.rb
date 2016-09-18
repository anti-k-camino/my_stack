class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource 
  before_action :set_question, only:[:index, :create]
  before_action :set_answer, only:[:show]

  api :GET, '/questions/:question_id/answers', 'This is index for all answers'
  def index
    @answers = @question.answers
    render json: @answers
  end

  api :GET, '/questions/:question_id/answers/id', 'This answer by id'
  def show
    render json: @answer, serializer: AnswerSerializer
  end

  api :POST, '/questions/:question_id/answers', 'This creates a new answer'
  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner
    if @answer.save
      render json: @answer, status: 200
    else
      render json: { errors: @answer.errors.full_messages }, status: 422
    end
  end

  protected

  def set_answer
    @answer = Answer.find(params[:id])
  end
  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end 