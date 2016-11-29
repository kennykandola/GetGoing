class ResponsesController < ApplicationController
  before_action :set_post, :require_user

  def create

    @response = @post.responses.build(responses_params)
    @response.user = current_user

    if @response.save
      redirect_to :back
    else
      render root_path
    end

def top_responses
  @response = Post.find(params[:response_id])

  respond_to do |format|
    if @top_responses.save

      format.html { redirect_to @post, notice: 'Top 3 Responses were selected :)'}
    end


  end
end


    Responses.submitted(response).deliver_later
    redirect_to @post
  end

  private
    def set_post
      @post = Post.find(params[:post_id])
    end

  def responses_params
    params.required(:response).permit(:body, :user_id)
  end
end
