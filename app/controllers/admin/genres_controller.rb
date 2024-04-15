class Admin::GenresController < ApplicationController

  
  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      flash[:notice] = "ジャンルを登録しました。"
      redirect_to admin_genres_path
    else
      @genres = Genre.all
      flash.now[:alert] = "登録に失敗しました。"
      render :index
    end
  end
  
  def index
    @genres = Genre.all
    @genre = Genre.new
    
    
  end
  
  def update
    @genre_edit = Genre.find(params[:id])
    if @genre_edit.update(genre_params)
      flash[:notice] = "編集が完了しました。"
      redirect_to admin_genres_path
    else
      flash.now[:alert] = "編集に失敗しました。"
      render :index
    end
  end
  
  private
  
  def genre_params
    params.require(:genre).permit(:name)
  end
  
end
