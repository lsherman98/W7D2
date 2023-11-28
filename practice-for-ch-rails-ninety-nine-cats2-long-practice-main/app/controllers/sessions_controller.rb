class SessionsController < ApplicationController
  before_action :require_logged_out

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by_credentials(params[:user][:username], params[:user][:password])

    if @user
      login!(@user)
      redirect_to cats_url
    else
      render :new
    end

  end

  def destroy
    if current_user
      current_user.reset_session_token!
      session[:session_token] = nil
      @current_user = nil
    end
  end

end
