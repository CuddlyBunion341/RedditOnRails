class AddPostTypeAndStatusEnumsToPosts < ActiveRecord::Migration[7.0]
  def change
    rename_column :posts, :post_type, :old_post_type
    add_column :posts, :post_type, :integer, default: 0

    rename_column :posts, :status, :old_status
    add_column :posts, :status, :integer, default: 0

    Post.all.each do |post|
      post.post_type = %w[text media link].index(post.old_post_type)
      post.status = %w[draft public archived].index(post.old_status)
      post.save!
    end

    remove_column :posts, :old_post_type
    remove_column :posts, :old_status
  end
end
