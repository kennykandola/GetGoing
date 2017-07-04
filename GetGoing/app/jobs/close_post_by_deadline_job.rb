class ClosePostByDeadlineJob < ApplicationJob
  queue_as :default

  def perform(post)
    post.close
  end
end
