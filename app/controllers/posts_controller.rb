class PostsController < ApplicationController
  include EmotionHelper
  before_action :current_user
  # before_action :users_post

  def edit
    @source = params[:source]
    @post = DatabaseFacade.lookup_post(current_user, params[:post_id])
    @emotions_grid = words_only(DatabaseFacade.emotions)
  end

  def update
    DatabaseFacade.update_post(post_params)
    params[:source] == 'dashboard' ? (redirect_to dashboard_path) : (redirect_to posts_path)
  end

  def destroy

  end

  def index
    require 'pry' ; binding.pry
    # DatabaseFacade.user_post_history(current_user)
  end

end