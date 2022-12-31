module ApplicationHelper
  def nav_link(link_text, link_path)
    # https://stackoverflow.com/questions/3705898/best-way-to-add-current-class-to-nav-in-rails-3
    class_name = current_page?(link_path) ? "active" : ""

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end

  def form_error(model, field)
    if model.errors[field].any?
      content_tag(:div, class: "form-error") do
        model.errors[field].join("<br />").html_safe
      end
    end
  end

  def error_class(model, field)
    "has-error" if model.errors[field].any?
  end

  def user_avatar(user, class_name = "")
    link_to user_path(user.username), class: "user-avatar__wrapper" do
      if user.avatar.attached?
        image_tag user.avatar, class: "user-avatar #{class_name}"
      else
        image_tag "default-avatar.png", class: "user-avatar #{class_name}"
      end
    end
  end
end
