class Public::HomesController < ApplicationController
  def top
    @posts = Post.all
    @genres = Genre.all
    @tags = Tag.all.page(params[:page]).per(6)
    @post_favorite_ranks = @posts.find(Favorite.group(:post_id).order('count(post_id) desc').pluck(:post_id))
    # @users = User.all
    # @followe_ranks = User.find(Relationship.group(:follower_id).order('count(follower_id)desc').pluck(:follower_id))
    # @user = @followe_ranks.user   
    
    follower_counts = Relationship.group(:followed_id).count
    sorted_user_ids = follower_counts.keys.sort_by { |user_id| -follower_counts[user_id] }
    @top_users = User.where(id: sorted_user_ids.take(3))
  end

  def about
  end
end
