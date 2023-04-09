class Public::PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
  end

  def index
      @user = current_user
      @post = Post.new
      @posts = Post.all
  end

  def edit
  end

  def create
      @post = Post.new(post_params)
      @post.user_id = current_user.id
   if @post.save
      redirect_to post_path(@post.id)
   else
      @posts = Post.all
      render 'index'
   end
  end

  def update
  end

  def destroy
  end

 private

  def post_params
    params.require(:post).permit(:title, :body, :image)
  end
end
