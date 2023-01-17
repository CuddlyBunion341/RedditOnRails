module VoteHelper
  def vote_button(model, upvote = true, controller = :post)
    active = !model.votes.find_by(user: Current.user, isUpvote: upvote).nil?
    active_class = active ? ' active' : ''
    vote_string = upvote ? 'upvote' : 'downvote'
    class_name = "vote-btn #{vote_string} #{active_class}"
    upvoteable = model.user_id != Current.user&.id
    action = "click->#{controller}##{vote_string}"

    content_tag :button, 'aria-label': vote_string, class: class_name, disabled: !upvoteable,
                         data: { action: action } do
      render 'shared/vote', upvote: upvote, active: active
    end
  end

  def upvote_button(model, controller)
    vote_button(model, true, controller)
  end

  def downvote_button(model, controller)
    vote_button(model, false, controller)
  end
end
