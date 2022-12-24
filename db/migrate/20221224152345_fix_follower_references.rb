class FixFollowerReferences < ActiveRecord::Migration[7.0]
  def change
    remove_reference :followers, :user, null: false, foreign_key: true
    remove_reference :followers, :follower, null: false, foreign_key: true

    add_reference :followers, :user, null: false, foreign_key: { to_table: :users }
    add_reference :followers, :follower, null: false, foreign_key: { to_table: :users }
  end
end
