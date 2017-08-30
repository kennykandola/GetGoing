class WizardStepsService
  def initialize(params)
    @session = params[:session]

  end

  def clear_new_post_wizard
    @session.delete(:post)
  end
end
