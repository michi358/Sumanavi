class Public::SearchesController < ApplicationController
  
  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]

    if @model == "User"
      @model_name = "ユーザー"
      @records = User.search_for(@content, @method).page(params[:page])
    elsif @model == "Post"
      @model_name = "投稿"
      @records = Post.search_for(@content, @method).page(params[:page])
    elsif @model == "Genre"
      @model_name = "カテゴリー"
      @genres = Genre.search_for(@content, @method)
      @post_ids = Post.where(genre_id: @genres.pluck(:id)).pluck(:id)
      @records = Post.where(id: @post_ids).page(params[:page])
    else @model == "Tag"
      @model_name = "タグ"
      @tags = Tag.search_for(@content, @method)
      @post_ids = PostTag.where(tag_id: @tags.pluck(:id)).pluck(:post_id)
      @records = Post.where(id: @post_ids).page(params[:page])
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
