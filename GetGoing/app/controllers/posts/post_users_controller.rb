# This controller handles users invitation to posts
class Posts::PostUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    emails = extract_emails_to_array(post_users_params[:email]) if post_users_params[:email].present?
    emails.each do |email|
      invite_user(email)
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def post_users_params
    params.require(:post_user).permit(:email)
  end

  def invite_user(email)
    post_user = PostUser.new(email: email, role: 'invited_user', post: @post)
    authorize post_user
    post_user.save
    post_user.user.notify_existing_about_invitation if post_user.user.invitation_token.blank?
  end

  def extract_emails_to_array(emails)
    reg = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
    emails.scan(reg).uniq
  end
end
