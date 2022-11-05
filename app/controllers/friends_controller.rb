class FriendsController < ApplicationController
  def index
    @friends = UserFacade.friends(current_user)
    # TODO the use of users plural indicates multiple responses, AMM thinks this should be just one or nothing, an exact search
    @users = UserFacade.search(params[:email]) if params[:email]
  end
end
