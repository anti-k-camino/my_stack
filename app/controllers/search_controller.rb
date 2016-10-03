class SearchController < ApplicationController
  skip_authorization_check
  def index
    @results = Search.search_selection(params[:query], params[:model])
  end
end
