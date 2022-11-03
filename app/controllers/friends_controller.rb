class FriendsController < ApplicationController
  def index
  end

  def create
    @users = UserFacade.search(params[:email])
    render :index
  end
end
