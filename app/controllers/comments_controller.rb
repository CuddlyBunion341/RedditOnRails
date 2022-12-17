class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comment_params)
    @comment.user = Current.user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @post, notice: "Comment was successfully created." }
        format.js { }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
