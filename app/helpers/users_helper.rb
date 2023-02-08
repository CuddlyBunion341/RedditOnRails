module UsersHelper
  def user_tab_link(link_text, user, tab = link_text.downcase)
    link_path = user_path user.username, tab: tab

    class_name = 'active' if current_page?(link_path)
    class_name = 'active' if params[:tab].blank? && tab == 'overview'

    content_tag(:li, class: class_name) do
      link_to link_text, link_path
    end
  end
end
