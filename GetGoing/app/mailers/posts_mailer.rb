class PostsMailer < ActionMailer::Base
  default from: "kennykandola89@gmail.com"

  def send_diffusion new_mail, user
    @message = new_mail
    mail(to: user.email, subject: "New Post")
  end



end


