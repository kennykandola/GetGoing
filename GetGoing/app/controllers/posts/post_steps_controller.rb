class Posts::PostStepsController < ApplicationController
  include Wicked::Wizard

  steps :welcome, :destinations

  def show
    @post = Post.new
    respond_to do |format|
      format.js { render_wizard(@post, formats: 'js') }
    end
  end

  def update
    case step
    when :welcome
      @post = Post.new(post_params)
      session[:post] = @post.attributes
      @wizard_path = next_wizard_path
      render next_step, format: :js
    when :destinations
      binding.pry
      session[:post] = session[:post].merge(post_params)
      @post = Post.new(session[:post])
      @post.owner = current_user if current_user.present?
      @post.save
      redirect_to post_path(@post)
    end

  end

  private

  def post_params
    params.require(:post).permit(:title, :who_is_traveling)
  end
end
