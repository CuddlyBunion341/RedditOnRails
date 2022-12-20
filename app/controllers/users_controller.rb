class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find_by(username: params[:username])
    @tab = params[:tab]

    valid_tabs = %w[overview posts comments saved drafts]
    private_tabs = %w[saved drafts]
    @tab = "overview" unless valid_tabs.include?(@tab)

    if @user.nil?
      redirect_to root_path, alert: "User not found"
      return
    end

    unless @user == Current.user
      if private_tabs.include?(@tab)
        redirect_to user_path(@user.username), alert: "You are not authorized to view this page"
        return
      end
    end
  end
end
