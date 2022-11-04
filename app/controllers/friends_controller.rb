class FriendsController < ApplicationController
  def index
    @friends = UserFacade.friends_of(current_user)
    @user = UserFacade.search(params[:email]) if params[:email]
  end
end
