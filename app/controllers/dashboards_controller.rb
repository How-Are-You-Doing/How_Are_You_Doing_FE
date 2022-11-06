class DashboardsController < ApplicationController
  before_action :current_user

  def show
    # return show_recent_post if recently_posted?
    if params[:description]
      new_post = UserPost.new(post_params)
      @recent_post = DatabaseFacade.new_post(new_post)
    elsif params[:emotion]
      @emotion = params[:emotion].split('-')
    else
      @emotions_grid = DatabaseFacade.emotions
    end
    @pending_requests = DatabaseFacade.pending_requests(current_user.google_id)
  end

  private

  def post_params
    params[:user_google_id] = current_user.google_id
    params.permit(:description, :emotion, :user_google_id, :post_status)
  end

  # def recently_posted?
  #   latest_post = DatabaseFacade.last_post(@current_user.google_id)
  #   latest_post.created_at > 12.hours.ago
  # end

  # def show_recent_post
  #   backend_post_data = DatabaseFacade.last_post(current_user.google_id)
  #   @last_post = Post.new(backend_post_data)
  # end

end