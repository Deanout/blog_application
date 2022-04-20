class SearchController < ApplicationController
  def index
    @query = Post.includes(:rich_text_body, :user, :category).ransack(params[:q])
    @posts = @query.result(distinct: true)
  end
end
