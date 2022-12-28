class PostsController < ApplicationController
  def index
    if params[:sort] == "top"
      @posts = Post.all.order(score: :desc)
    else
      @posts = Post.all.order(created_at: :desc)
    end

    @active_users = User.joins(:posts).group(:id).order("count(posts.id) desc").limit(10)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = Current.user.id
    @post.status = "public"

    if params[:draft]
      @post.status = "draft"
      @post.save(validate: false)
      redirect_to root_path, notice: "Successfully created draft!"
    elsif @post.save
      redirect_to post_path(@post), notice: "Successfully created post!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = Post.find(params[:id])
    if @post.user != Current.user
      redirect_to root_path, alert: "You can only edit your own posts."
    end

    unless @post.draft?
      redirect_to root_path, alert: "You can only edit draft posts."
    end

    render :edit
  end

  def update
    @post = Post.find(params[:id])
    @post.user = Current.user

    if @post.user != Current.user
      redirect_to root_path, alert: "You can only edit your own posts."
    elsif !@post.draft?
      redirect_to root_path, alert: "You can only edit draft posts."
    elsif params[:publish]
      if @post.publish
        redirect_to post_path(@post), notice: "Successfully published post!"
      else
        render :edit, status: :unprocessable_entity
      end
    elsif params[:draft]
      @post.assign_attributes(post_params)
      @post.save(validate: false)
      redirect_to root_path, notice: "Successfully updated draft!"
    end
  end

  def destroy
    @post = Post.find(params[:id])

    respond_to do |format|
      if !@post.draft?
        msg = "You can only delete drafts!"
        format.html { redirect_to root_path, notice: msg }
        format.json { render json: { error: msg } }
      elsif Current.user != @post.user
        msg = "You can only delete your own posts!"
        format.html { redirect_to root_path, notice: msg }
        format.json { render json: { error: msg } }
      else
        msg = "Post deleted successfully!"
        format.html { redirect_to root_path, notice: msg }
        format.json { render json: { msg: msg } }
        @post.destroy
      end
    end
  end

  def publish
    @post = Post.find(params[:id])

    if @post.user != Current.user
      redirect_to root_path, alert: "You can only publish your own posts."
    elsif @post.publish
      redirect_to post_path(@post), notice: "Successfully published post!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.order(created_at: :desc)
  end

  def vote(upvote = true)
    render json: { error: "You must be logged in to vote" }, status: :unauthorized and return unless Current.user
    render json: { error: "You can't vote on your own posts" }, status: :bad_request and return if Current.user.id == params[:user_id].to_i

    @post = Post.find(params[:id])
    @post.score = @post.vote(Current.user, upvote)
    @post.save

    render json: { html: render_post(@post) }
  end

  alias_method :upvote, :vote

  def downvote
    vote(false)
  end

  def save()
    render json: { error: "You must be logged in to save" }, status: :unauthorized and return unless Current.user

    @post = Post.find(params[:id])
    @post.bookmark(Current.user)

    render json: { html: render_post(@post) }
  end

  def archive
    @post = Post.find(params[:id])

    if @post.user_id != Current.user&.id
      render json: { error: "You can only archive your own posts." }, status: :unauthorized
    else
      @post.update(status: "archived")

      render json: { html: render_post(@post) }
    end
  end

  def render_post(post)
    partial = "post"
    if params[:variant]
      partial += "_#{params[:variant]}"
    end

    render_to_string(partial: partial, locals: { post: post })
  end

  private

  def draft_params
    params.require(:post).permit(:title)
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
