class ResponsesController < ApplicationController
  before_action :set_post, :require_user

  def create
    @response = @post.responses.build(responses_params)
    @response.user_id = current_user.id

    if @response.save
      Responses.submitted(response).deliver_later
      redirect_to :back
    else
      render root_path
    end
  end

  def update
    @response = Response.find(params[:id])
    post = Post.find(@response.post_id)

    if @response.user_id == current_user.id && post.user_id == current_user.id
      #TODO Can or not update own post's own responses

    elsif post.user_id == current_user.id # update own post's responses
      # maybe this is better
      @response.update(set_top_responses_params)

      #TODO how to deal with error message 
    else
      raise "permissions is wrong"
    end

    render :nothing => true, :status => 200
  end

  private
    def set_post
      @post = Post.find(params[:post_id])
    end

  def responses_params
    params.required(:response).permit(:body, :top)
  end

  def set_top_responses_params
    params.required(:response).permit(:top) 
  end
end
