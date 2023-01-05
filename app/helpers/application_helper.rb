module ApplicationHelper
  def nav_link(link_text, link_path, class_name = "")
    # https://stackoverflow.com/questions/3705898/best-way-to-add-current-class-to-nav-in-rails-3
    class_name += current_page?(link_path) ? " active" : ""

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

  def user_avatar(user, class_name = "", data = {})
    link_to user_path(user.username), class: "user-avatar__wrapper" do
      user_avatar_img(user, class_name, data)
    end
  end

  def user_avatar_img(user, class_name = "", data = {})
    img = user.avatar.attached? ? user.avatar : "default-avatar.png"
    image_tag img, class: "user-avatar #{class_name}", alt: user.username, data: data
  end

  def attachment_identifier(attachment)
    attachment.filename.to_s + attachment.byte_size.to_s + attachment.created_at.to_i.to_s # won't work
  end
end
