class Users::InvitationsController < Devise::InvitationsController
  def update
    binding.pry
    invitation_service = InvitationService.new(update_resource_params[:invitation_token])
    if invitation_service.fb_token?
      
      redirect_to root_path
    else
      super
    end
  end

end
