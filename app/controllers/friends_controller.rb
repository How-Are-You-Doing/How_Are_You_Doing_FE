class FriendsController < ApplicationController
  def index
    @user = UserFacade.search(params[:email]) if params[:email]
    @accepted_friends = UserFacade.relationships_filter(current_user, "accepted")
    @pending_friends = UserFacade.relationships_filter(current_user, "pending")
    @friends = UserFacade.friends(current_user)
    @friend_requests_sent = DatabaseFacade.sent_requests(current_user.google_id)
  end

  def create
    UserFacade.send_friend_request(current_user, params[:email])
    redirect_to "/friends"
  end
end
