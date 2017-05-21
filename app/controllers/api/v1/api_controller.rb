class Api::V1::ApiController < Api::V1::BaseController
  def search
    search_term = params[:search]
    @search_result = Search.new(search_term)
    render json: @search_result.as_json
  end
end
