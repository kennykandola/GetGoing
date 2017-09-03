class PostsMailer < ApplicationMailer
  def new_post(user, post)
    @user = user
    @post = post
    mail(to: user.email, subject: "Thanks for creating a new post on TripTippa!")
  end

  def inactivity_email(post, user)
    @post = post
    mail(to: user.email, subject: "Your post '#{post.title}' has been
                                   inactive for the last week")
  end

  def matching_destination(post, user)
    @post = post
    @user = user
    mail(to: user.email, subject: "Post suggestion: #{post.title} with places you have been")
  end

  def upvoted_link(post, actor, recipient, booking_link)
    @post = post
    @actor = actor
    @recipient = recipient
    @booking_link = booking_link
    mail(to: recipient.email, subject: "#{actor.first_name} up-voted your recommended link")
  end

  def daily_posts(user)
    @new_posts = Post.new_posts
    @open_posts = Post.status_open
    @user = user
    mail(to: user.email, subject: "Daily new/open posts")  if @new_posts.present? || @open_posts.present?
  end
end
