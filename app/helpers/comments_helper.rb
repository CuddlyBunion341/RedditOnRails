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

  def comment_reply_button(_comment)
    content_tag(:button, class: 'reply_btn', data: { action: 'comment#toggleReply' }) do
      icon('fa-regular', 'comment').concat(' Reply')
    end
  end
end
