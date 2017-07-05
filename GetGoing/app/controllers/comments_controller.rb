class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_response

  def new
    @comment = @response.comments.build
    respond_to :js
  end

  def create
    @comment = @response.comments.build(comments_params)
    @comment.user_id = current_user.id
    respond_to :js if @comment.save
  end

  def destroy
    @comment = Comment.find(params[:id])
    @response = @comment.response
    @comment.destroy
    respond_to :js
  end

  private

  def set_response
    @response = Response.find(params[:response_id])
  end

  def comments_params
    params.required(:comment).permit(:body, :response_id)
  end
end
