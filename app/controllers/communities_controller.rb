class CommunitiesController < ApplicationController
  before_action :require_login, only: %i[new create join]

  def index
    @communities = Community.all
  end

  def list
    @communities = Community.all

    respond_to do |format|
      format.json { render json: @communities, methods: :posts_count }
      format.html { render :index }
    end
  end

  def show
    @community = Community.find_by(shortname: params[:name])

    @posts = if params[:sort] == 'top'
               @community.posts.published.order('pin_owner_id DESC, score DESC')
             else
               @community.posts.published.order('pin_owner_id DESC, created_at DESC')
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
