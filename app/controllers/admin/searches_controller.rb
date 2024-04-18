class Admin::SearchesController < ApplicationController

  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]

    if @model == "User"
      @users = User.search_for(@content, @method).page(params[:page])
    elsif @model == "Post"
      @posts = Post.search_for(@content, @method).page(params[:page])
    elsif @model == "Genre"
      @genres = Genre.search_for(@content, @method).page(params[:page])
    else 
      @tags = Tag.search_for(@content, @method).page(params[:page])
    end
  end

  def genre_search
    @genre_id = params[:genre_id]
    @posts = Post.where(genre_id: @genre_id).page(params[:page])
    @genre = Genre.find(@genre_id)
  end

  def tag_search
    @tag_id = params[:tag_id]
    @tag = Tag.find(@tag_id)
    @posts = @tag.posts.page(params[:page])
  end
  
end
