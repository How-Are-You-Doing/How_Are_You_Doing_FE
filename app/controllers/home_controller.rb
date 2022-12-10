class HomeController < ApplicationController
include EmotionHelper

  def welcome
    @emotions_grid = words_only(DatabaseFacade.emotions)
  end


end