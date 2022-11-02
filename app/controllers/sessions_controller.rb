class SessionsController < ApplicationController

  def create
    user = User.find_or_create_by(user_params[:email])
    user.update(user_params)

    
    # post to backend database
    # DatabaseFacade.find_or_create_user(user_params)
    # if DatabaseFacade.find_user(user.email) == []
      # DatabaseFacade.create_new_user
    #   conn = Faraday.new(url: 'http://localhost:5000')
    #   conn.post "/users" do |req|
    #     req.params['google_id'] = user.google_id
    #     req.params['name'] = user.name
    #     req.params['email'] = user.email
    #   end
    # end
    
    session[:user_id] = user.id
    redirect_to dashboard_path
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