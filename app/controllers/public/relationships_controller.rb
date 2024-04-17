class Public::RelationshipsController < ApplicationController
  
  
  def create
    user = User.find(params[:user_id])
    current_user.follow(user)
    redirect_to request.referer
  end
  
  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user)
    redirect_to  request.referer
  end
  # フォロー中
  def followings
    @user = User.find(params[:user_id])
    @users = @user.followings.page(params[:page])
  end
  # フォロワー
  def followers
    @user = User.find(params[:user_id])
    @users = @user.followers.page(params[:page])
  end
  
end
