class ResponsesMailer < ApplicationMailer
  def submitted(response, user)
    @response = response
    @user = user
    mail(to: user.email, subject: "New response on #{@response.post.title}")
  end

  def submitted_top(post)
    @post = post
    @user = post.owner
    mail(to: @user.email, subject: 'Thanks for finalizing top responses')
  end

  def new_comment_email(response, actor, recipient, comment)
    @response = response
    @actor = actor
    @recipient = recipient
    @comment = comment
    mail(to: recipient.email,
         subject: "New comment on \"#{response.post.title}\"")
  end
end
