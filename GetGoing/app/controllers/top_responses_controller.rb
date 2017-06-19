class TopResponsesController < ApplicationController
  before_action :set_post, :require_user


  def show


  end

  private
  def set_post
    @post = Post.find(params[:post_id])
  end

end