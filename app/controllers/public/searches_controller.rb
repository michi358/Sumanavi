class Public::SearchesController < ApplicationController
  
  def genre_search
    @genre_id = params[:genre_id]
    @posts = Post.where(genre_id: @genre_id).page(params[:page])
    @genre = Genre.find(@genre_id)
  end
  
end
