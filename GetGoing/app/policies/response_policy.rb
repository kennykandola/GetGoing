class ResponsePolicy < ApplicationPolicy
  attr_reader :user, :response

  def initialize(user, response)
    @user = user
    @response = response
  end

  def create?
    @user && @response.post.status_open?
  end

  def update?
    @user && (@user.admin? || @user.moderator?)
  end

  def destroy?
    @user && (@user.admin? || @user.moderator?)
  end

  def comment?
    @user &&
      (@user.owns_post?(@response.post) || # creator of post
      (@response.comments.present? && @user.owns_response?(@response))) # creator of response
  end

  def show_comments?
    @response.public_type? || (@response.private_type? && @user.member_of_discussion?(@response)) || (@user.admin? || @user.moderator?)
  end
end
