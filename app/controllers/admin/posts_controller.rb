class Admin::PostsController < ApplicationController
  def index
     # ソート機能
    if params[:latest]
      @posts = Post.published.latest.page(params[:page]).per(10)
    elsif params[:old]
      @posts = Post.published.old.page(params[:page]).per(10)
    else
      @posts = Post.published.all.page(params[:page]).per(10)
    end
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
    @post_tags = @post.tags
  end
  
  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to admin_posts_path
  end
end
