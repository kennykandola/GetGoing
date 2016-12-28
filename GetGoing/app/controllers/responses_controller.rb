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
    post = Post.find(@response.post_id)

    if @response.user_id == current_user.id && post.user_id == current_user.id
      #TODO Can or not update own post's own responses
      redirect_to :back, notice: 'TODO'
    elsif post.user_id == current_user.id # update own post's responses
      # maybe use set_top_responses_params is better
      if @response.update(set_top_responses_params)
        redirect_to :back, notice: 'Top responses have been saved.'
      else
        redirect_to :back, notice: 'Something wrong'
      end 
    else
      redirect_to :back, notice: 'permissions wrong'
    end
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
