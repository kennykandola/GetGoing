class PostsMailer < ActionMailer::Base
  default from: "kennykandola89@gmail.com"

  def send_diffusion new_mail, user
    @message = new_mail
    mail(to: user.email, subject: "New Post")
  end

  def inactivity_email(post, user)
    @post = post
    mail(to: user.email, subject: "Your post '#{post.title}' has been
                                   inactive for the last week")
  end

  def suggest_post(post, user)
    @post = post
    mail(to: user.email, subject: "Post suggestion: #{post.owner.first_name} just posted #{post.title} with places you have been")
  end

  def suggest_post_nearby(post, user)
    @post = post
    mail(to: user.email, subject: "Post suggestion: #{post.owner.first_name} just posted #{post.title} with places nearby to locations you have been")
  end
end
