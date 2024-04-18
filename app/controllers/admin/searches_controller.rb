class Admin::SearchesController < ApplicationController
  
  def genre_search
    @genre_id = params[:genre_id]
    @posts = Post.where(genre_id: @genre_id).page(params[:page])
    @genre = Genre.find(@genre_id)
  end
  
  def tag_search
    @tag_id = params[:tag_id]
    #検索されたタグを受け取る
    @tag = Tag.find(@tag_id)
　　#検索されたタグに紐づく投稿を表示
    @posts = Post.where(tag_id: @tag_id).page(params[:page])
  end
end
