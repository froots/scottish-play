class PusherController < ApplicationController
  protect_from_forgery :except => :auth # stop rails CSRF protection for this action
  
  def server
  end

  def client
    @current_user = current_user
  end
  
  def login
    session[:user_id] = params[:user_id]
    if params[:server] == 'true'
      redirect_to :action => :server
    else
      redirect_to :action => :client
    end
  end

  def auth
    if current_user
      response = Pusher[params[:channel_name]].authenticate(params[:socket_id], {
        :user_id => current_user,
        :user_info => {
          :name => current_user
        }
      })
      render :json => response
    else
      render :text => "Forbidden", :status => '403'
    end
  end

end
