class ResponsesController < ApplicationController
  before_action :set_post, :require_user

  def create

    @response = @post.responses.build(responses_params)
    @response.user_id = current_user.id
    @post = Post.find(params[:post_id])


    if @response.save
      @post = Post.find(params[:post_id])
      ResponsesMailer.submitted(@response).deliver_later
      redirect_to @post, notice: 'Response was successfully created.'
    else
      render root_path
    end
  end


  def top
    @post = Post.find(params[:post_id])
  end

  def top_email
    @post = Post.find(params[:post_id])
    ResponsesMailer.submitted_top(@response).deliver_later
    redirect_to @post, notice: 'Top Responses Have Been Finalized, Thank You!'


  end

  def update



    @response = Response.find(params[:id])



    if @response.update_attribute(:top, params[:response][:top]) && @response.post.responses.where(top: true).size <= 3
      redirect_to :back, notice: 'Top responses have been saved.'
    else
      if @response.post.responses.where(top: true).size > 3
        redirect_to :back, notice:'Please select no more than 3 top responses'
      else
      redirect_to :back, notice: 'Something wrong'
    end
    end
    end


  private
    def set_post
      @post = Post.find(params[:post_id])
    end

  def responses_params
    params.required(:response).permit(:body, :user_id, :top)
  end

  end


