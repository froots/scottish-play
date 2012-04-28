class PlayerController < ApplicationController
  def index
    render :index, :layout => 'player'
  end

  def testing
  end
end
