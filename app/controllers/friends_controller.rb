class FriendsController < ApplicationController
  before_action do
    if current_user.nil?
      flash[:error] = "You must be signed in to do that!"
      redirect_to '/'
    end
  end

  def index
    @user = UserFacade.search(params[:email]) if params[:email]
    @accepted_friends = UserFacade.relationships_filter(current_user, "accepted")
    @pending_friends = UserFacade.relationships_filter(current_user, "pending")
    @friends = UserFacade.friends(current_user)
    @friend_request_sent = DatabaseFacade.sent_friend_requests(current_user.google_id)
  end

  def create
    UserFacade.send_friend_request(current_user, params[:email])
    flash[:success] = "Friend Request Sent Successfully"
    redirect_to '/friends'
    #will be used to create new Friends(friendship) relation and send request to User dashboard
  end

  def show
    #TODO switch over to api/v1/friends/:id once it exists
    @friend = UserFacade.friends(current_user).find { |friend| friend.google_id == params[:google_id]}
    @posts = UserFacade.friend_posts(@friend.google_id)
  end
end
