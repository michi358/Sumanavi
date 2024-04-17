class Admin::UsersController < ApplicationController
  def index
    @users = User.all.page(params[:page])
  end
  
  def show
    @user = User.find(params[:id])  
  end
  
  def update
    user = User.find(params[:id])
    if user.update(user_params)
       flash[:notice] = "変更処理が完了しました。"
      redirect_to admin_user_path(user.id)
    else
      flash.now[:alert] = "変更に失敗しました。"
      render :show
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:is_active)
  end
  
end
