class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comment_params)
    @comment.user = Current.user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @post, notice: 'Comment was successfully created.' }
        format.js {}
        format.json { render :show, status: :created, location: @comment }
      else
        format.html {}
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def vote(upvote = true)
    render json: { error: 'You must be logged in to vote' }, status: :unauthorized and return unless Current.user

    @comment = Comment.find(params[:id])
    @comment.update(score: @comment.vote(Current.user, upvote))

    render json: { html: render_comment(@comment) }
  end

  alias upvote vote

  def downvote
    vote(false)
  end

  def save
    render json: { error: 'You must be logged in to save' }, status: :unauthorized and return unless Current.user

    @comment = Comment.find(params[:id])
    @comment.bookmark(Current.user)

    render json: { html: render_comment(@comment) }
  end

  def reply
    @comment = Comment.find(params[:id])
    new_params = comment_params.merge(user: Current.user, post: @comment.post)
    @reply = @comment.children.new(new_params)

    if @reply.save
      render json: { html: render_comment(@reply, 1) }
    else
      render json: { error: 'Failed to save reply', errors: @reply.errors }, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end

  def render_comment(comment, indents = 0)
    partial = 'comment'
    render_to_string(partial: partial, locals: { comment: comment, indents: indents })
  end
end
