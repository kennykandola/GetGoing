class InactivePostsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    open_posts_without_deadline = Post.status_open.where(expired_at: nil)

    # close posts which have been inactive for more than 14 days
    open_posts_without_deadline.where('updated_at < ?', 14.days.ago).each do |post|
      post.close
    end

    open_posts_without_deadline.status_open

    # send emails to post's creators which has posts that was inactive for 7 days
    open_posts_without_deadline.where(updated_at: (Date.today.beginning_of_day - 7.days)..(Date.today.end_of_day - 7.days)).each do |post|
      PostsMailer.inactivity_email(post, post.owner).deliver_later
    end


  end
end
