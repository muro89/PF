class Admin::UsersController < ApplicationController

  def index
     @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :is_deleted)
  end
end
