class DashboardsController < ApplicationController
  before_action :current_user

  def show
    # return show_recent_post if recently_posted?
    if params[:description]
      DatabaseFacade.new_post(post_params)
      show_recent_post
    elsif params[:emotion]
      @emotion = params[:emotion].split('-')
    else
      @emotions_grid = DatabaseFacade.emotions
    end
    @pending_requests = DatabaseFacade.pending_requests(current_user.google_id)
  end

  private

  def post_params
    {
      description: params[:description],
      emotion: params[:emotion],
      gui: current_user.google_id
    }
  end

  # def recently_posted?
  #   latest_post = DatabaseFacade.last_post(@current_user.google_id)
  #   latest_post.created_at > 12.hours.ago
  # end

  def show_recent_post
    @recent_post = DatabaseFacade.last_post(current_user.google_id)
  end

end
