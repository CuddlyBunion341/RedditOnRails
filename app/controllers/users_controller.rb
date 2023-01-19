class UsersController < ApplicationController
  before_action :require_login, only: %i[edit update follow]

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(username: params[:username])
    @followers = @user.followers.pluck(:follower_id).map { |id| User.find(id) }
    @tab = params[:tab]

    valid_tabs = %w[overview posts comments saved drafts]
    private_tabs = %w[saved drafts]
    fullwidth_tabs = %w[posts comments]
    @tab = 'overview' unless valid_tabs.include?(@tab)
    @fullwidth = fullwidth_tabs.include?(@tab)

    if @user.nil?
      # TODO: Add a 404 page, add JSON response, 404 status code
      redirect_to root_path, alert: 'User not found'
      return
    end

    return if @user == Current.user
    return unless private_tabs.include?(@tab)

    redirect_to user_path(@user.username), alert: 'You are not authorized to view this page'
    nil
  end

  def edit
    @user = User.find_by(username: params[:username])
    return if @user == Current.user

    # TODO: Add JSON response
    redirect_to user_path(@user.username), alert: 'You are not
      authorized to view this page'
  end

  def update
    @user = User.find(params[:username].to_i) # TODO: Fix this

    unless @user == Current.user
      # TODO: Add JSON response
      redirect_to user_path(@user.username), alert: 'You are not
      authorized to view this page'
      return
    end

    if params[:user][:avatar]
      @user.avatar.purge
      @user.avatar.attach(params[:user][:avatar])
    end

    if @user.update!(user_params)
      # TODO: Add JSON response
      redirect_to user_path(@user.username), notice: 'User updated
      successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def follow
    if Current.user.nil?
      # TODO: Add JSON response
      redirect_to request.referrer || root_path, alert: 'You must be logged in to perform that action'
      return
    end

    @user = User.find_by(username: params[:username])
    if Current.user.following?(@user)
      Current.user.unfollow(@user)
    else
      Current.user.follow(@user)
    end

    redirect_to user_path(@user.username)
  end

  private

  def user_params
    params.require(:user).permit(:name, :username, :email, :password, :password_confirmation, :bio, :avatar)
  end
end
