class FriendsController < ApplicationController
  def index
    @user = UserFacade.search(params[:email]) if params[:email]
    @accepted_friends = UserFacade.relationships_filter(current_user, "accepted")
    @rejected_friends = UserFacade.relationships_filter(current_user, "rejected")
    @pending_friends = UserFacade.relationships_filter(current_user, "pending")
  end

  def create

  end
end
