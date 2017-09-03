class DailyPostsJob < ApplicationJob
  queue_as :default

  def perform
    User.tippas.each do |tippa|
      PostsMailer.daily_posts(tippa).deliver_later
    end
  end
end
