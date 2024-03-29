class PostsController < ApplicationController
  before_action :require_login, only: %i[new create edit update destroy publish]

  def index
    @posts = if params[:sort] == 'top'
               Post.order(score: :desc)
             else
               Post.order(created_at: :desc)
             end

    @active_users = User.joins(:posts).group(:id).order('count(posts.id) desc').limit(10)
    @active_communities = Community.all # for now
  end

  def new
    @communities = Community.all
    @post = Post.new
  end

  def create
    @communities = Community.all
    @post = Post.new(post_params)
    @post.user = Current.user
    @post.community = Community.find(params[:post][:community_id])
    @post.status = 'published'

    if params[:draft]
      @post.status = 'draft'
      @post.save(validate: false)
      redirect_to root_path, notice: 'Successfully created draft!'
    elsif @post.save
      redirect_to post_path(@post), notice: 'Successfully created post!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @communities = Community.all
    @post = Post.find(params[:id])
    redirect_to root_path, alert: 'You can only edit your own posts.' unless @post.user == Current.user

    redirect_to root_path, alert: 'You can only edit draft posts.' unless @post.draft?

    render :new
  end

  def update
    @communities = Community.all
    @post = Post.find(params[:id])

    if @post.user != Current.user
      redirect_to root_path, alert: 'You can only edit your own posts.'
    elsif !@post.draft?
      redirect_to root_path, alert: 'You can only edit draft posts.'
    elsif params[:publish]
      if @post.update(post_params) && @post.publish
        redirect_to post_path(@post), notice: 'Successfully published post!'
      else
        render :new, status: :unprocessable_entity
      end
    elsif params[:draft]
      @post.assign_attributes(post_params)
      @post.save(validate: false)
      redirect_to root_path, notice: 'Successfully updated draft!'
    end
  end

  def destroy
    @post = Post.find(params[:id])

    respond_to do |format|
      if !@post.draft?
        msg = 'You can only delete drafts!'
        format.html { redirect_to root_path, notice: msg }
        format.json { render json: { error: msg } }
      elsif Current.user != @post.user
        msg = 'You can only delete your own posts!'
        format.html { redirect_to root_path, notice: msg }
        format.json { render json: { error: msg } }
      elsif @post.destroy
        msg = 'Post deleted successfully!'
        format.html { redirect_to root_path, notice: msg }
        format.json { render json: { msg: msg } }
      else
        msg = 'Something went wrong!'
        format.html { redirect_to root_path, notice: msg }
        format.json { render json: { error: msg } }
      end
    end
  end

  def publish
    @post = Post.find(params[:id])

    if @post.user != Current.user
      redirect_to root_path, alert: 'You can only publish your own posts.'
    elsif @post.publish
      redirect_to post_path(@post), notice: 'Successfully published post!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.filter { |c| c.parent_id.nil? }
    @comments = order_comments(@comments)
  end

  def order_comments(comments)
    ordered_comments = []

    comments.sort_by(&:created_at).reverse.each do |comment|
      ordered_comments << comment
      ordered_comments += order_comments(comment.children)
    end

    ordered_comments
  end

  def vote(upvote = true)
    # TODO: Add html response
    render json: { error: 'You must be logged in to vote' }, status: :unauthorized and return unless Current.user

    if Current.user.id == params[:user_id].to_i
      render json: { error: 'You can\'t vote on your own posts' }, status: :bad_request
    end

    @post = Post.find(params[:id])
    @post.score = @post.vote(Current.user, upvote)
    @post.save

    render json: { html: render_post(@post) }
  end

  alias upvote vote

  def downvote
    vote(false)
  end

  def save
    # TODO: Add html response
    render json: { error: 'You must be logged in to save' }, status: :unauthorized and return unless Current.user

    @post = Post.find(params[:id])
    @post.bookmark(Current.user)

    render json: { html: render_post(@post) }
  end

  def archive
    # TODO: Add html response
    @post = Post.find(params[:id])

    if @post.user_id != Current.user&.id
      render json: { error: 'You can only archive your own posts.' }, status: :unauthorized
    else
      @post.update(status: 'archived')

      render json: { html: render_post(@post) }
    end
  end

  def render_post(post)
    partial = 'post'
    params[:variant] && partial += "_#{params[:variant]}"

    render_to_string(partial: partial, locals: { post: post, show_pins: params[:showPin] })
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :url, :community_id, :post_type, media: [])
  end
end
