class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource   

  api :GET, '/questions', 'This is index for all questions'
  def index
    @questions = Question.all
    render json: @questions  
  end
end