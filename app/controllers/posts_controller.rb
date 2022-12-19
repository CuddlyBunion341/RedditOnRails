class PostsController < ApplicationController
  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = Current.user.id
    if @post.save
      redirect_to root_path, notice: "Successfully created post!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.order(created_at: :desc)
  end

  def destroy
    @post = Post.find(params[:id])

    if @post.user_id != Current.user.id
      redirect_to root_path, alert: "You can only delete your own posts"
    else
      @post.destroy
      redirect_to root_path, notice: "Successfully deleted post!"
    end
  end

  def vote(upvote = true)
    render json: { error: "You must be logged in to vote" }, status: :unauthorized and return unless Current.user

    @post = Post.find(params[:id])
    @post.score = @post.vote(Current.user, upvote)
    @post.save

    render json: { html: render_to_string(partial: "post", locals: { post: @post }) }
  end

  alias_method :upvote, :vote

  def downvote
    vote(false)
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
