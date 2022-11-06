class SessionsController < ApplicationController

  def create
    user = User.find_or_create_by(email: user_params[:email])
    user.update(user_params)

    
    # post to backend database
    # DatabaseFacade.find_or_create_user(user_params)
    if UserFacade.search(user.email) == []
      UserFacade.create(user)
    end
    session[:user_id] = user.id
    redirect_to dashboard_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Goodbye!"
  end


  private

  def auth_hash
    request.env['omniauth.auth']
  end

  def user_params
    { google_id: auth_hash[:uid],
      email: auth_hash[:info][:email],
      name: auth_hash[:info][:name],
      token: auth_hash[:credentials][:token] }
  end
end
