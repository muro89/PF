class Public::PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id]) 
  end

  def index
      @post = Post.new
      @posts = Post.all
  end

  def edit
  end

  def create
      post = Post.new(post_params)
      post.user_id = current_user.id
   if post.save
      redirect_to post_path(post)
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
    params.require(:post).permit(:title, :body)
  end
end
