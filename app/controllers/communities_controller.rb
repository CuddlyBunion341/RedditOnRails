class CommunitiesController < ApplicationController
  def index
    @communities = Community.all
  end

  def show
    @community = Community.find_by(shortname: params[:name])
    if params[:sort] == "top"
      @posts = @community.posts.where(status: "public").order(score: :desc)
    else
      @posts = @community.posts.where(status: "public").order(created_at: :desc)
    end
  end
end
