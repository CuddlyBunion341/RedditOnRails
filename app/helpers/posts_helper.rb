module PostsHelper
  def vote_button(post, upvote = true)
    active = post.votes.find_by(user: Current.user, isUpvote: upvote) ? " active" : ""
    vote_string = upvote ? "upvote" : "downvote"
    class_name = "vote_btn " + vote_string + active
    upvoteable = post.user_id != Current.user&.id && !post.archived?

    content_tag :button, class: class_name, disabled: !upvoteable, data: { :action => "click->post#" + vote_string } do
      icon("fa", "arrow-" + (upvote ? "up" : "down"))
    end
  end

  def upvote_button(post)
    vote_button(post, true)
  end

  def downvote_button(post)
    vote_button(post, false)
  end

  def save_button(post)
    saved = Current.user&.saved?(post)
    class_name = "save_btn " + (saved ? " active" : "")

    content_tag :button, class: class_name, disabled: Current.user.nil? || post.archived?, data: { :action => "click->post#save" } do
      if saved
        icon("fa-solid", "bookmark").concat(" Unsave")
      else
        icon("fa-regular", "bookmark").concat(" Save")
      end
    end
  end

  def archive_button(post)
    return unless Current.user&.id == post.user_id
    return if post.archived?

    content_tag :button, class: "archive_button", data: { :action => "click->post#archive" } do
      icon("fa", "box-archive").concat(" Archive")
    end
  end

  def delete_button(post)
    return unless Current.user&.id == post.user_id
    return if post.archived?

    content_tag :button, class: "delete_button", data: { :action => "click->post#delete" } do
      icon("fa", "trash-alt").concat(" Delete")
    end
  end

  def tab_button(form, tab, content, checked = false)
    name = %w[ text media link ][tab]
    content_tag :label, class: "tab_button" do
      concat form.radio_button :post_type, name, checked: checked, data: { :action => "click->post-form#showTab", :tab => "#{tab}" }
      concat content
    end
  end
end
