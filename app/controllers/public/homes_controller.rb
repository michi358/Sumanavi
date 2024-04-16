class Public::HomesController < ApplicationController
  def top
    @posts = Post.all
    @genres = Genre.all
  end

  def about
  end
end
