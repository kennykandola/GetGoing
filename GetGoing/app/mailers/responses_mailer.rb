class ResponsesMailer < ActionMailer::Base
  default from: "kennykandola89@gmail.com"

  def submitted(response)
    @response = response

    mail(to: @response.post.user.email, subject: 'Sample Email')
  end

  def submitted_top(post)
    @post = post
    mail(to: @post.user.email, subject: 'Sample Email')
  end

  def new_comment_email(response, user)
    @response = response
    mail(to: user.email,
         subject: "New comment on \"#{response.post.title}\"")
  end
end
