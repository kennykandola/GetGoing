class PostPolicy < ApplicationPolicy
  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
    @claim_service = ClaimsService.new(user: @user, post: @post)
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
    potential_responder? && @claim_service.claim_accepted?
  end

  def claim?
    potential_responder? && !@claim_service.claim_accepted? &&
      !(waitlisted? && !@claim_service.post_available?) && !@claim_service.claim_responded?
  end

  def potential_responder?
    @user && @post.status_open? &&
      !(@user.owns_post?(@post) || @post.invited?(@user))
  end

  def cancel_claim?
    potential_responder? && create_response?
  end

  def waitlisted?
    potential_responder? && @claim_service.waitlisted?
  end
end
