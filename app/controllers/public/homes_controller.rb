class Public::HomesController < ApplicationController
  def top
    @posts = Post.all
    @genres = Genre.all
    @tags = Tag.all.page(params[:page]).per(6)
    @post_favorite_ranks = @posts.find(Favorite.group(:post_id).order('count(post_id) desc').pluck(:post_id))
    @followe_ranks = User.left_joins(:followers).group(:id).order('COUNT(users.id) DESC').limit(3)
  end
  
  def next_page
    @tags = Tag.page(params[:page])
    respond_to do |format|
      format.html { render partial: 'tag_list', object: @tags }
    end
  end

  def about
  end
end
