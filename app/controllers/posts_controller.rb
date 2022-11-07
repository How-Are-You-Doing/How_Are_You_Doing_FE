class PostsController < ApplicationController
  before_action :current_user
  # before_action :users_post

  def edit
    @source = params[:source]
    @post = DatabaseFacade.lookup_post(post_id)
  end

  def update
    DatabaseFacade.update_post(post_params)
    params[:source] == 'dashboard' ? (redirect_to dashboard_path) : (redirect_to posts_path)
  end

  def create

  end

  def destroy

  end

  def index
    # DatabaseFacade.user_post_history(current_user)
  end

  private

  def users_post
    
  end
end