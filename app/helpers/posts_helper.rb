module PostsHelper
  def vote_button(post, upvote = true)
    active = post.votes.find_by(user: Current.user, isUpvote: upvote) ? " active" : ""
    vote_string = upvote ? "upvote" : "downvote"
    class_name = "vote_btn " + vote_string + active

    content_tag :button, class: class_name, disabled: Current.user.nil?, data: { :action => "click->post#" + vote_string } do
      icon("fa", "arrow-" + (upvote ? "up" : "down"))
    end
  end

  def upvote_button(post)
    vote_button(post, true)
  end

  def downvote_button(post)
    vote_button(post, false)
  end
end
