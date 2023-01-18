module SaveHelper
  def save_button(model, stimulus_controller)
    saved = Current.user && model.saved_by?(Current.user)
    class_name = "save_btn #{saved ? 'active' : ''}"

    content_tag :button, class: class_name, disabled: Current.user.nil?,
                         data: { action: "click->#{stimulus_controller}#save" } do
      if saved
        icon('fa-solid', 'bookmark').concat(' Unsave')
      else
        icon('fa-regular', 'bookmark').concat(' Save')
      end
    end
  end
end
