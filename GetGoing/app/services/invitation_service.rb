# The service handles Facebook invitation authentication process
class InvitationService
  def initialize(params)
    @invitation_token = params[:invitation_token]
  end

  def fb_token?
    invited_post.present?
  end

  def invited_post
    Post.where(invitation_token: @invitation_token).first
  end


end
