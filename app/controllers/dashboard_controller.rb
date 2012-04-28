class DashboardController < ApplicationController
  def index
  	@scene = Scene.find(6)
  	@characters = @scene.characters
  end
end
