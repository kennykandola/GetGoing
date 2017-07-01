ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587,
    :domain => "mail.google.com",
    :user_name => ENV['GMAIL_USERNAME'],
    :password => ENV['GMAIL_PASSWORD'],
    :authentication => :login,
    :enable_starttls_auto => true
}
