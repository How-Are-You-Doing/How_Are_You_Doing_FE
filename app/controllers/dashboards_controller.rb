class DashboardsController < ApplicationController
  before_action :current_user

  def show
    @pending_requests = DatabaseFacade.pending_requests(current_user.google_id)
    return show_recent_post if recently_posted?
    if params[:description]
      new_post = UserPost.new(post_params)
      @recent_post = DatabaseFacade.new_post(new_post)
    elsif params[:emotion]
      @emotion = params[:emotion].split('-')
    else
      @emotions_grid = DatabaseFacade.emotions
    end
  end

  private

  def recently_posted?
    latest_post = DatabaseFacade.last_post(@current_user.google_id)
    latest_post.created_at < 12.hours.ago
  end

  def show_recent_post
    @recent_post = DatabaseFacade.last_post(current_user.google_id)
  end
end