class Public::UsersController < ApplicationController
  before_action :authenticate_user!, only:[:edit,:update,:unsubscribe,:destroy]
  before_action :is_matching_login_user, only:[:edit,:update]
  before_action :ensure_guest_user, only:[:edit,:update]

  def show
    @user = User.find(params[:id])
    # ソート機能
    if params[:latest]
      @posts = @user.posts.published.latest.page(params[:page]).per(10)
    elsif params[:old]
      @posts = @user.posts.published.old.page(params[:page]).per(10)
    else
      @posts = @user.posts.published.all.page(params[:page]).per(10)
    end

    if user_signed_in? && current_user == @user
      @following_posts = Post.published.includes(:user).where(user_id: current_user.following_ids)
      @favorite_posts = Post.published.joins(:favorites).where(favorites: { user_id: current_user.id })
      @draft_posts = current_user.posts.draft.all.page(params[:page]).per(10)
      @unpublished_posts = current_user.posts.unpublished.all.page(params[:page]).per(10)
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "編集が完了しました。"
      redirect_to user_path(@user.id)
    else
      flash.now[:alert] = "編集に失敗しました。"
      render :edit
    end
  end

  def unsubscribe
    @user = current_user
    if @user.guest_user?
      flash[:alert] = "ゲストユーザーではアクセス権限がありません"
      redirect_to user_path(current_user)
    end
  end

  def withdraw
    @user = current_user
      if @user.guest_user?
        flash[:alert] = "ゲストユーザーではアクセス権限がありません"
        redirect_to user_path(current_user)
      end
    @user.update(is_active: false)
    reset_session
    flash[:notice] = "退会処理が完了いたしました。ご利用ありがとうございました。"
    redirect_to root_path
  end

  def destroy
    @user = current_user
      if @user.guest_user?
        flash[:alert] = "ゲストユーザーではアクセス権限がありません"
        redirect_to user_path(current_user)
      end
    @user.destroy
    reset_session
    flash[:notice] = "退会処理が完了いたしました。ご利用ありがとうございました。"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile_image)
  end
  # ゲストログインでのアクセス制限
  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest_user?
      flash[:alert] = "ゲストユーザーではアクセス権限がありません"
      redirect_to user_path(current_user)
    end
  end
  # アクセス制限 ログイン中userと制限ページ先のユーザーが同じかどうか確認
  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      flash[:alert] = "アクセス権限がありません"
      redirect_to root_path
    end
  end

end
