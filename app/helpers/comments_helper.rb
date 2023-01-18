module CommentsHelper
  include VoteHelper
  include SaveHelper

  def comment_upvote_button(comment)
    vote_button(comment, true, 'comment')
  end

  def comment_downvote_button(comment)
    vote_button(comment, false, 'comment')
  end

  def comment_save_button(comment)
    save_button(comment, 'comment')
  end
end
