class ResponsesController < ApplicationController
  before_action :set_post
  before_action :authenticate_user!

  def create

    @response = @post.responses.build(responses_params)
    @response.user_id = current_user.id
    @post = Post.find(params[:post_id])

    @claim_service = ClaimsService.new(post: @response.post, user: current_user)
    if @claim_service.claim_accepted? && @response.save
      # @response.user.increment!(:score, by = 10)
      @post = Post.find(params[:post_id])
      # ResponsesMailer.submitted(@response).deliver_later
      NotificationService.new(actor: current_user, notifiable: @response, post: @post).new_response
      @claim_service.response_created
      redirect_to @post, notice: 'Response was successfully created.'
    else
      redirect_to @post, notice: 'Response wasn\'t created.'
    end
  end


  def top
    @post = Post.find(params[:post_id])
  end

  def set_top
    @response = Response.find(params[:id])
    if @response.post.responses.where(top: true).size <= 3 && @response.update_attribute(:top, params[:top])
      # redirect_back fallback_location: @post, notice: 'Top responses have been saved.'
      flash.now[:notice] = 'Top responses have been saved.'
    elsif @response.post.responses.where(top: true).size >= 4 && @response.update_attribute(:top, params[:top])
      # redirect_back fallback_location: @post, notice:'Please select no more than 3 top responses'
      flash.now[:notice] = 'Please select no more than 3 top responses'
    else
      # redirect_back fallback_location: @post, notice: 'Something wrong'
      flash.now[:notice] = 'Something wrong'
    end
    respond_to :js
  end

  def top_email
    @post = Post.find(params[:post_id])
    @post.responses.where(top: true).each do |response|
      UserScoreService.new(user: response.user).update_score('finalize')
    end
    ResponsesMailer.submitted_top(@post).deliver_later
    redirect_to @post, notice: 'Top Responses Have Been Finalized, Thank You!'
  end

  def edit
    @response = Response.find(params[:id])
    authorize @response
    respond_to :js
  end

  def update
    @response = Response.find(params[:id])
    @post = @response.post
    authorize @response
    @response.update(body: params[:response][:body])
    @responses = @post.responses
    @structured_booking_links = BookingLinksService.new(post: @post)
                                                   .structured_booking_links
    respond_to :js
  end

  def destroy
    @response = Response.find(params[:id])
    @post = @response.post
    if @response.destroy
      ClaimsService.new(post: @response.post, user: @response.user).response_deleted
      UserScoreService.new(user: @response.user).update_score('remove')
    end
    respond_to :js
  end

  private
    def set_post
      @post = Post.find(params[:post_id])
    end

  def responses_params
    params.required(:response).permit(:body, :user_id, :top)
  end

  end
