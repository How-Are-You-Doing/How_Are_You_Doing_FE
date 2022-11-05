class FriendsController < ApplicationController
  def index
    @user = UserFacade.search(params[:email]) if params[:email]
    @accepted_friends = UserFacade.relationships_filter(current_user, "accepted")
    @pending_friends = UserFacade.relationships_filter(current_user, "pending")
    @friends = UserFacade.friends(current_user)
  end

  def create
    #will be used to create new Friends(friendship) relation and send request to User dashboard
  end
end
