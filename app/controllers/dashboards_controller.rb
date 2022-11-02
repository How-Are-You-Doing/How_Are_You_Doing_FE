class DashboardsController < ApplicationController
  def show

    @feelings_grid = DatabaseFacade.feelings
  end
end