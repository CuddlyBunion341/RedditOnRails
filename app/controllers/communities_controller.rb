class CommunitiesController < ApplicationController
  before_action :require_login, only: %i[new create join]

  def index
    @communities = Community.all
  end

  def show
    @community = Community.find_by(shortname: params[:name])
    @posts = if params[:sort] == 'top'
               @community.posts.where(status: 'public').order(score: :desc)
             else
               @community.posts.where(status: 'public').order(created_at: :desc)
             end
  end

  def new
    @community = Community.new
  end

  def create
    @community = Community.new(community_params)
    puts @community.inspect
    @community.shortname = @community.name
    @community.owner = Current.user

    if @community.save
      redirect_to communities_path(@community.shortname)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def join
    @community = Community.find_by(shortname: params[:name])
    @community.join(Current.user)
    redirect_to community_path(@community.shortname)
  end

  private

  def community_params
    params.require(:community).permit(:name, :shortname, :description)
  end
end
