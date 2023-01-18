module VoteHelper
  def vote_button(model, upvote, stimulus_controller)
    active = !model.votes.find_by(user: Current.user, isUpvote: upvote).nil?
    active_class = active ? ' active' : ''
    vote_string = upvote ? 'upvote' : 'downvote'
    class_name = "vote-btn #{vote_string} #{active_class}"
    upvoteable = model.user_id != Current.user&.id
    action = "click->#{stimulus_controller}##{vote_string}"

    content_tag :button, 'aria-label': vote_string, class: class_name, disabled: !upvoteable,
                         data: { action: action } do
      render 'shared/vote', upvote: upvote, active: active
    end
  end
end
