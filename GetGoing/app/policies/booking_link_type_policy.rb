class BookingLinkTypePolicy < ApplicationPolicy
  attr_reader :user, :booking_link_type

  def initialize(user, booking_link_type)
    @user = user
    @booking_link_type = booking_link_type
  end

  def index?
    @user && @user.admin?
  end

  def create?
    @user && @user.admin?
  end

  def update?
    @user && @user.admin?
  end

  def destroy?
    @user && @user.admin?
  end
end
