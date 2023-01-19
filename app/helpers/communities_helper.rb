module CommunitiesHelper
  def join_button(community)
    is_active = community.members.exists?(user: Current.user)
    button_text = is_active ? 'Leave' : 'Join'
    class_name = "join-btn #{'active' if is_active}"

    link_to button_text, join_community_path(community.shortname), class: class_name
  end
end
