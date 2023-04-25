class Admin::PostCommentsController < ApplicationController

 def index
   @postcomment = PostComment.all
 end

 def destroy
   PostComment.find(params[:id]).destroy
    @post_comment = PostComment.new
    redirect_to  admin_post_comments_path
 end

end
