class Admin::SearchesController < ApplicationController

  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]

    if @model == "User"
      @users = User.search_for(@content, @method).page(params[:page])
    else @model == "Post"
      @posts = Post.search_for(@content, @method).page(params[:page])
  end

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
    pp "aaa", @tag
  end
end
