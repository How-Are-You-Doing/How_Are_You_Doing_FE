class FriendsController < ApplicationController
  def index
    @friends = UserFacade.friends
    @users = UserFacade.search(params[:email]) if params[:email]
  end
end
