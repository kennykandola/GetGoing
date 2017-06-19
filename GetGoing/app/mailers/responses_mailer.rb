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




end