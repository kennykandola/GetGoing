module PostsHelper
  def current_status(post)
    return 'open' if post.status
    'closed'
  end
end
