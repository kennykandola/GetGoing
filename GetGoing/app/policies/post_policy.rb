class PostPolicy < ApplicationPolicy
  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end

  def update?
    @user && (@user.admin? || @user.moderator? ||
      @user.owns_post?(@post) || @post.invited?(@user))
  end

  def destroy?
    @user && (@user.admin? || @user.moderator? ||
      @user.owns_post?(@post) || @post.invited?(@user))
  end

  def create_response?
    @user && @post.status_open? &&
      !(@user.owns_post?(@post) || @post.invited?(@user))
  end
end
