module UsersHelper
  def user_tab_link(link_text, user, tab = link_text.downcase)
    link_path = user_path user.username, tab: tab

    class_name = 'active' if current_page?(link_path)
    class_name = 'active' if params[:tab].blank? && tab == 'overview'

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end

  def follow_button(user)
    return if user == Current.user

    if Current.user.nil?
      link_to 'Follow', follower_path(user.username), class: 'follow-btn disabled'
    elsif user.followed_by?(Current.user)
      link_to 'Unfollow', follower_path(user.username), method: :post, class: 'follow-btn active'
    else
      link_to 'Follow', follower_path(user.username), method: :post, class: 'follow-btn'
    end
  end
end
