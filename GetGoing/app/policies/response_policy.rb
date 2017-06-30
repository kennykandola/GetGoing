class ResponsePolicy < ApplicationPolicy
  attr_reader :user, :response

  def initialize(user, response)
    @user = user
    @post = response
  end

  def create?
    
  end

  def update?
    @user && (@user.admin? || @user.moderator?)
  end

  def destroy?
    @user && (@user.admin? || @user.moderator?)
  end
end
