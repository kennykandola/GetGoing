# This controller handles users invitation to posts
class Posts::PostUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    emails = extract_emails_to_array(post_users_params[:email]) if post_users_params[:email].present?
    invitation_status = 'Invitation has not been sent, please make sure entered correct email address'
    if emails.present?
      emails.each do |email|
        if email == current_user.email
          invitation_status = 'You already own thit Post, instead you can invite your friends to join.'
        elsif invite_user(email)
          invitation_status = 'Thank you! Your invitation has been successfully sent'
        end
      end
    end
    render 'posts/invitation_sent', format: :js, locals: { invitation_status: invitation_status }
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
