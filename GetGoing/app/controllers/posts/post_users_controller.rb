# This controller handles users invitation to posts
class Posts::PostUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    post_user = @post.post_users.new(email: post_users_params[:email], role: 'invited_user')
    post_user.post = @post

    post_user.save
  end

  private
    def set_post
      @post = current_user.posts.find(params[:post_id])
    end

    def post_users_params
      params.require(:post_user).permit(:email)
    end
end
