class ResponsesController < ApplicationController
  before_action :set_post, :require_user

  def create
    @response = @post.responses.build(responses_params)
    @response.user_id = current_user.id

    if @response.save
      #Responses.submitted(@response).deliver_later need to change view for this
      redirect_to @post, notice: 'Response was successfully created.'
    else
      render root_path
    end
  end

  def update
    @response = Response.find(params[:id])

    if @response.update_attribute(:top, params[:response][:top])
      redirect_to :back, notice: 'Top responses have been saved.'
    else
      redirect_to :back, notice: 'Something wrong'
    end
  end

  private
    def set_post
      @post = Post.find(params[:post_id])
    end

  def responses_params
    params.required(:response).permit(:body, :user_id, :top_response)
  end
end
