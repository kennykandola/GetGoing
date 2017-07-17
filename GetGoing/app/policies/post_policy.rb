class PostPolicy < ApplicationPolicy
  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end

  def update?
    @user && (@user.admin? || @user.moderator? || @user.owns_post?(post))
  end

  def destroy?
    @user && (@user.admin? || @user.moderator? || @user.owns_post?(post))
  end

  def create_response?
    @user && @post.status_open?
  end
end
