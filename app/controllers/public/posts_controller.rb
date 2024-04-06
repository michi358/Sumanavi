class Public::PostsController < ApplicationController

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
    @posts = Post.all
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "投稿が成功しました。"
      redirect_to post_path(@post.id)
    else
      flash.now[:alert] = "編集に失敗しました。"
      render :new
    end

  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "編集が完了しました。"
      redirect_to post_path(@post.id)
    else
      flash.now[:alert] = "編集に失敗しました。"
      render :edit
    end
  end

  def destroy
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end

end
