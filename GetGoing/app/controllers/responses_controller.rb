class ResponsesController < ApplicationController
  before_action :set_post, :require_user

  def create

    @response = @post.responses.build(responses_params)
    @response.user = current_user

    :top_response = false

    if @response.save
      redirect_to :back
    else
      render root_path
    end


    end


    Responses.submitted(response).deliver_later
    redirect_to @post
  end

def update

##???
end

  private
    def set_post
      @post = Post.find(params[:post_id])
    end

  def responses_params
    params.required(:response).permit(:body, :user_id, :top_response)
  end
end
