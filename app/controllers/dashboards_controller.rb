class DashboardsController < ApplicationController
  before_action :current_user
  
  def show

    @emotions_grid = DatabaseFacade.emotions
  end
end