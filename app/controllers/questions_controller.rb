class QuestionsController < BaseController
  before_action :set_question, only:[:show, :edit, :update, :destroy]
  def index
    @questions = Question.all    
  end
  def show   
  end
  def new
    @question = Question.new
  end
  def edit 
    if !current_user.permission? @question
      render :show, id: @question, notice: 'Restricted' and return 
    end 
  end
  def update
    if !current_user.permission? @question
      render :show, id: @question, notice: 'Restricted'
    elsif @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end
  def create
    @question = Question.new(question_params)
    @question.user_id = current_user.id
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def destroy
    if current_user.permission? @question    
      @question.destroy
      redirect_to questions_path, notice: 'Question successfully destroyed.'
    else
      render :show, id: @question, notice: 'Restricted'
    end
  end
  
  private
  def set_question
    @question = Question.find params[:id]
  end
  def question_params
    params.require(:question).permit(:title, :body)
  end
end
