module ApplicationHelper
  def nav_link(link_text, link_path, class_name = '', link_icon = '')
    # https://stackoverflow.com/questions/3705898/best-way-to-add-current-class-to-nav-in-rails-3
    class_name += current_page?(link_path) ? ' active' : ''
    content_tag(:li, class: class_name) do
      link_to link_path do
        concat link_icon
        concat link_text
      end
    end
  end

  def nav_button(button_text, link_path, class_name, button_icon = '')
    content_tag(:li) do
      button_to link_path, method: :delete, class: class_name do
        concat button_icon
        concat button_text
      end
    end
  end

  def form_error(model, field)
    return unless model.errors[field].any?

    content_tag(:div, class: 'form-error') do
      model.errors[field].join('<br />').html_safe
    end
  end

  def error_class(model, field)
    'has-error' if model.errors[field].any?
  end

  def user_avatar(user, class_name = '', data = {})
    link_to user_path(user.username), class: 'user-avatar__wrapper' do
      user_avatar_img(user, class_name, data)
    end
  end

  def user_avatar_img(user, class_name = '', data = {})
    img = user.avatar.attached? ? user.avatar : 'default-avatar.png'
    image_tag img, class: "user-avatar #{class_name}", alt: user.username, data: data
  end

  def attachment_identifier(attachment)
    attachment.filename.to_s + attachment.byte_size.to_s + attachment.created_at.to_i.to_s # won't work
  end

  def sort_option(shortname, displayname, icon, default = false)
    is_active = (default && params[:sort].blank?) || params[:sort] == shortname
    active = is_active ? 'active' : ''
    path = params.permit(:per_page).merge(sort: shortname)

    link_to path, class: "sort sort-#{shortname} #{active}" do
      icon('fa', icon).concat(" #{displayname}")
    end
  end
end
