class AddTypeToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :post_type, :string
  end
end
