class AddDefaultTypeToPosts < ActiveRecord::Migration[7.0]
  def change
    change_column_default :posts, :post_type, from: nil, to: "text"
    if Post.where(post_type: nil).any?
      Post.where(post_type: nil).update_all(post_type: "text")
    end
  end
end
