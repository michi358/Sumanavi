class Public::UsersController < ApplicationController
  before_action :authenticate_user!, only:[:edit,:update,:unsubscribe,:destroy]
  before_action :is_matching_login_user, only:[:edit,:update]
  before_action :ensure_guest_user, only:[:edit,:update]

  def show
    @user = User.find(params[:id])
    # ソート機能
    if params[:latest]
      @posts = @user.posts.published.latest.page(params[:mypost]).per(5)
    elsif params[:old]
      @posts = @user.posts.published.old.page(params[:mypost]).per(5)
    else
      @posts = @user.posts.published.all.page(params[:mypost]).per(5)
    end

    if user_signed_in? && current_user == @user
      if params[:latest_following]
        @following_posts = Post.published.includes(:user).where(user_id: current_user.following_ids).latest.page(params[:following_posts]).per(5)
      elsif params[:old_following]
        @following_posts = Post.published.includes(:user).where(user_id: current_user.following_ids).old.page(params[:following_posts]).per(5)
      else
        @following_posts = Post.published.includes(:user).where(user_id: current_user.following_ids).all.page(params[:following_posts]).per(5)
      end

      if params[:latest_favorites]
        @favorite_posts = Post.published.joins(:favorites).where(favorites: { user_id: current_user.id }).latest.page(params[:favorite_posts]).per(5)
      elsif params[:old_favorites]
        @favorite_posts = Post.published.joins(:favorites).where(favorites: { user_id: current_user.id }).old.page(params[:favorite_posts]).per(5)
      else
        @favorite_posts = Post.published.joins(:favorites).where(favorites: { user_id: current_user.id }).all.page(params[:favorite_posts]).per(5)
      end

      if params[:latest_draft]
        @draft_posts = current_user.posts.draft.latest.page(params[:draft_posts]).per(5)
      elsif params[:old_draft]
        @draft_posts = current_user.posts.draft.old.page(params[:draft_posts]).per(5)
      else
        @draft_posts = current_user.posts.draft.all.page(params[:draft_posts]).per(5)
      end
      if params[:latest_unpublished]
        @unpublished_posts = current_user.posts.unpublished.latest.page(params[:unpublished_posts]).per(5)
      elsif params[:old_unpublished]
        @unpublished_posts = current_user.posts.unpublished.old.page(params[:unpublished_posts]).per(5)
      else
        @unpublished_posts = current_user.posts.unpublished.all.page(params[:unpublished_posts]).per(5)
      end
    end

    respond_to do |format|
      format.html
      format.js
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
