class SearchesController < ApplicationController
  def display
    @search_term = params[:search]
    @search_result = Search.new(@search_term)
    @message = @search_result.name ? "First match:" : "No search results"
  end
end
