class SessionsController < ApplicationController
  before_action :require_login, only: %i[destroy]

  def new; end

  def create
    # TODO: Add json response
    user = User.find_by(username: params[:username])
    if user.present? && user.authenticate(params[:password])
      user.login
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Logged in successfully!'
    else
      flash.now[:alert] = 'Invalid email or password'
      render :new
    end
  end

  def destroy
    # TODO: Add json response
    Current.user.logout
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged Out'
  end
end
