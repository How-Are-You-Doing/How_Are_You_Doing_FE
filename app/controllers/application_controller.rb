class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  private

  def post_params
    params[:user_google_id] = current_user.google_id
    params.permit(:description, :emotion, :user_google_id, :post_status, :id)
  end
end
