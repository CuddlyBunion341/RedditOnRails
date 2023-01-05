class CommunitiesController < ApplicationController
  def index
    @communities = Community.all
  end

  def show
    @community = Community.find_by(shortname: params[:name])
    @active_users = User.joins(:posts).group(:id).order("count(posts.id) desc").limit(10)
  end
end
