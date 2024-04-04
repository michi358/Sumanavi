class Public::UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
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
      flash.now[:notice] = "編集に失敗しました。"
      render :edit
    end
      
  end
  
  def unsubscribe
  end
  
  def withdraw
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :profile_image)
  end
  
end
