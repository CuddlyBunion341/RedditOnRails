module PostsHelper
  def vote_button(post, upvote = true)
    arrow = upvote ? "↑" : "↓"
    active = post.votes.find_by(user: Current.user, isUpvote: upvote) ? " active" : ""
    vote_string = upvote ? "upvote" : "downvote"
    class_name = "vote_btn " + vote_string + active

    content_tag :button, arrow, class: class_name, disabled: Current.user.nil?, data: { :action => "click->post#" + vote_string }
  end

  def upvote_button(post)
    vote_button(post, true)
  end

  def downvote_button(post)
    vote_button(post, false)
  end
end
