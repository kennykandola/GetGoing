# Preview all emails at http://localhost:3000/rails/mailers/example_mailer
class WelcomeMailerPreview < ActionMailer::Preview

  def sample_mail_preview
    WelcomeMailer.welcome_user(User.first)
  end

end
