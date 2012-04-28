class DashboardController < ApplicationController
  def index
  	@characters = Character.find(:all)
  	@scene = Scene.find(6)
  end
end
