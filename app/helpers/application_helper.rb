module ApplicationHelper
  def nav_link(link_text, link_path)
    # https://stackoverflow.com/questions/3705898/best-way-to-add-current-class-to-nav-in-rails-3
    class_name = current_page?(link_path) ? "active" : ""

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end
end
