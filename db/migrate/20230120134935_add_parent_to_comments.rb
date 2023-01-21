class AddParentToComments < ActiveRecord::Migration[7.0]
  def change
    add_reference :comments, :parent, index: true, foreign_key: { to_table: :comments }, null: true
  end
end
