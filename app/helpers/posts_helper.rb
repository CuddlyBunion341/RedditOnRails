module PostsHelper
  include VoteHelper
  include SaveHelper

  def post_upvote_button(post)
    vote_button(post, true, 'post')
  end

  def post_downvote_button(post)
    vote_button(post, false, 'post')
  end

  def post_save_button(post)
    save_button(post, 'post')
  end

  def archive_button(post)
    return unless Current.user&.id == post.user_id
    return if post.archived?

    content_tag :button, class: 'archive_button', data: { action: 'click->post#archive' } do
      icon('fa', 'box-archive').concat(' Archive')
    end
  end

  def delete_button(post)
    return unless Current.user&.id == post.user_id
    return if post.archived?

    content_tag :button, class: 'delete_button', data: { action: 'click->post#delete' } do
      icon('fa', 'trash-alt').concat(' Delete')
    end
  end

  def tab_button(form, tab, content, checked = false)
    name = %w[text media link][tab]
    checked ||= params[:post][:post_type] == name if params[:post]

    content_tag :label, class: 'tab_button' do
      concat form.radio_button :post_type, name, checked: checked,
                                                 data: { action: 'click->post-form#showTab', tab: tab.to_s }
      concat content
    end
  end
end
