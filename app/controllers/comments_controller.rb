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
        format.html { }
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

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def render_comment(comment)
    partial = 'comment'
    render_to_string(partial: partial, locals: { comment: comment })
  end
end
