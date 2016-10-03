class SearchController < ApplicationController
  skip_before_action :authenticate_user!
  before_action      :load_results

  authorize_resource class: false

  def index
    respond_with @results
  end

  private

  def load_results
    models = %w(Questions Answers Users Comments)
    klass_model =
      if models.include?(params[:model])
        params[:model].classify.constantize
      else
        ThinkingSphinx
      end
    @results = klass_model.search(ThinkingSphinx::Query.escape(params[:query]))
  end
end
