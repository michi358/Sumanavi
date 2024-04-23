class Public::PostsController < ApplicationController
  before_action :authenticate_user!, only:[:new,:create,:edit,:update,:destroy]
  before_action :is_matching_login_user, only: [:edit,:update,:destroy]
  
  def index
    # ソート機能
    if params[:latest]
      @posts = Post.latest.page(params[:page]).per(10)
    elsif params[:old]
      @posts = Post.old.page(params[:page]).per(10)
    else
      @posts = Post.all.page(params[:page]).per(10)
    end
  end

  def new
    @post = Post.new
    @posts = Post.all
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    tag_list = params[:post][:name].split(',')
    if @post.save
      @post.save_tags(tag_list)
      flash[:notice] = "投稿が成功しました。"
      redirect_to post_path(@post.id)
    else
      flash.now[:alert] = "投稿に失敗しました。"
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
    @user = @post.user
    @post_tags = @post.tags
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(',')
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:name].split(',')
    if @post.update(post_params)
      @post.save_tags(tag_list)
      flash[:notice] = "編集が完了しました。"
      redirect_to post_path(@post.id)
    else
      flash.now[:alert] = "編集に失敗しました。"
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to user_path(current_user.id)
  end
  
  def rank
    # 投稿のいいね数ランキング
    @post_like_ranks = Post.find(Like.group(:post_id).order('count(post_id) desc').pluck(:post_id))
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :genre_id)
  end
  # アクセス制限をするため（before_actionで使うため)
  def is_matching_login_user
    post = Post.find(params[:id])
    unless post.user_id == current_user.id
      flash[:alert] = "アクセス権限がありません"
      redirect_to posts_path
    end
  end

end
