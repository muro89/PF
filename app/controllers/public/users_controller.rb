class Public::UsersController < ApplicationController

  def show
    @user  = User.find(params[:id])
    @posts  = @user.posts.page(params[:page]).per(5)
    @post  = Post.new

    @today_post = @posts.created_today
    @yesterday_post = @posts.created_yesterday
    @this_week_post = @posts.created_this_week
    @last_week_post = @posts.created_last_week
  end

  def index
    @user   = current_user
    @userid = current_user.id
    @users  = User.all.page(params[:page]).per(5)
    @posts  = @user.posts
    @post   = Post.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
      @user = User.find(params[:id])
   if @user.update(user_params)
      flash[:notice] = "You have updated!"
      redirect_to user_path(@user)
   else
      render :edit
   end
  end

  def search
    @user = User.find(params[:user_id])
    @posts = @user.posts
    @post = Post.new
    if params[:created_at] == ""
      @search_post = "日付を選択してください"#①
    else
      create_at = params[:created_at]
      @search_post = @posts.where(['created_at LIKE ? ', "#{create_at}%"]).count#②
    end
  end


  def withdrawal
    @user = User.find(params[:id])
    # is_deletedカラムをtrueに変更することにより削除フラグを立てる
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end


  def favorites
    @user    = User.find(params[:id])
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
  end


private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
end