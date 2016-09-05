# Preview all emails at http://localhost:3000/rails/mailers/responses
class ResponsesPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/responses/submitted
  def submitted
    Responses.submitted Response.first
  end

end
