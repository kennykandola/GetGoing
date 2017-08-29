class WizardStepsService
  def initialize(params)
    @session = params[:session]

  end

  def clear_new_post_wizard
    @session.delete(:post)
    @session.delete(:places)
    @session.delete(:who_is_traveling)
    @session.delete(:travel_start)
    @session.delete(:travel_end)
    @session.delete(:booking_link_type_ids)
    @session.delete(:main_place)
  end
end
