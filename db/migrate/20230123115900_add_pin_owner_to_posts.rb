class AddPinOwnerToPosts < ActiveRecord::Migration[7.0]
  def change
    add_reference :posts, :pin_owner, foreign_key: { to_table: :users }
  end
end
