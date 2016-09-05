class ResponsesController < ApplicationController
  before_action :set_post

  def create
    response = @post.responses.create! responses_params
    Responses.submitted(response).deliver_later
    redirect_to @post
  end

  private
    def set_post
      @post = Post.find(params[:post_id])
    end

  def responses_params
    params.required(:response).permit(:body)
  end
end
