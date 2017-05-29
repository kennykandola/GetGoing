ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587,
    :domain => "mail.google.com",
    :user_name => "kennykandola89@gmail.com",
    :password => "Steelers32!",
    :authentication => :login,
    :enable_starttls_auto => true
}