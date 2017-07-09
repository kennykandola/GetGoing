class CommentPolicy < ApplicationPolicy
  attr_reader :user, :comment

  def initialize(user, comment)
    @user = user
    @comment = comment
  end

  def create?
    @user &&
      (@user.owns_post?(@comment.response.post) || # creator of post
      (@comment.response.comments.present? && @user.owns_response?(@comment.response))) # creator of response
  end

  def destroy?
    @user && @user.moderator? || @user.admin?
  end
end
