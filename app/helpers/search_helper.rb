module SearchHelper
  def search_tab_link(link_text, tab = link_text.downcase)
    link_path = search_path tab: tab, q: params[:q]

    class_name = 'active' if current_page?(link_path)
    class_name = 'active' if params[:tab].blank? && tab == 'all'

    content_tag(:li, class: class_name) do
      link_to link_text, link_path
    end
  end
end
