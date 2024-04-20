class Public::HomesController < ApplicationController
  def top
    @posts = Post.all
    @genres = Genre.all
    @post_favorite_ranks = @posts.find(Favorite.group(:post_id).order('count(post_id) desc').pluck(:post_id))
  end

  def about
  end
end
