class Responses < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.responses.submitted.subject
  #
  def submitted(response)
    @response = response

    mail to: "kennykandola89@gmail.com", subject: 'New response!'
  end
end
