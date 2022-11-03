class DashboardsController < ApplicationController
  before_action :current_user
  
  def show
    # return show_recent_post if recently_posted?
    if params[:description]
      DatabaseFacade.new_post(post_params)
      show_recent_post
    elsif params[:emotion]
      @emotion = DatabaseFacade.emotion(params[:emotion])
    else
      @emotions_grid = DatabaseFacade.emotions
    end
  end

  private

  def post_params
    {
      description: params[:description],
      emotion_id: params[:emotion_id],
      gui: @current_user.google_id
    }
  end
end