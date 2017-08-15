class UserDecorator < ApplicationDecorator
  delegate_all

  def full_name
    "#{first_name} #{last_name}"
  end

  def profile_page_type
    tippa ? 'Tippa profile page' : 'Traveler profile page'
  end

  def score_value
    score ? score : 0
  end

end
