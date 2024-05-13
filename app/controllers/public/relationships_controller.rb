class Public::RelationshipsController < ApplicationController
  
  
  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user)
    if request.referer&.include?("users")
      @options= { class: "" }
    else
      @options= { button_size: "sm", class: "" }
    end
  end
  
  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
    if request.referer&.include?("users")
      @options= { class: "" }
    else
      @options= { button_size: "sm", class: "" }
    end
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
