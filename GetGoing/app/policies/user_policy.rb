class UserPolicy < ApplicationPolicy
  attr_reader :user, :user_object

  def initialize(user, user_object)
    @user = user
    @user_object = user_object
  end

  def index?
    @user && @user.admin?
  end

  def assign_as_admin?
    @user && @user.admin? && !@user_object.admin?
  end

  def assign_as_moderator?
    @user && @user.admin? && !@user_object.moderator?
  end

  def assign_as_simple_user?
    @user && @user.admin? && !@user_object.simple_user?
  end
end
