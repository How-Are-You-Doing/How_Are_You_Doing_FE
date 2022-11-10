class DashboardsController < ApplicationController
  include EmotionHelper
  before_action :current_user

  def show
    @pending_requests = DatabaseFacade.pending_requests_to_friendships(current_user.google_id)
    return show_recent_post if recently_posted?

    if params[:description]
      return back_to_description if description_empty?

      new_post = UserPost.new(post_params)
      @recent_post = DatabaseFacade.new_post(new_post)
      flash[:success] = "Post Created!" if @recent_post
    elsif params[:emotion]
      word = params[:emotion]
      definition = lookup_emotion(word).definition
      @emotion = [word, definition]
    else
      @emotions_grid = words_only(DatabaseFacade.emotions)
    end
  end

  private

  def recently_posted?
    latest_post = DatabaseFacade.last_post(current_user.google_id)
    return false if params[:post] || params[:emotion] || latest_post == {}

    latest_post.created_at.in_time_zone(0000) > 12.hours.ago.in_time_zone(0000)
  end

  def show_recent_post
    @recent_post = DatabaseFacade.last_post(current_user.google_id)
  end
end
