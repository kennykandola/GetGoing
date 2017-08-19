class PostUserPolicy < ApplicationPolicy
  attr_reader :user, :post_user

  def initialize(user, post_user)
    @user = user
    @post_user = post_user
  end

  def create?
    @post_user.post.owner.id == @user.id
  end

end
