class ResponsePolicy < ApplicationPolicy
  attr_reader :user, :response

  def initialize(user, response)
    @user = user
    @response = response
  end

  def create?
    @user && @response.post.open?
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
end
