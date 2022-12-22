class CreateFollowers < ActiveRecord::Migration[7.0]
  def change
    create_table :followers do |t|
      t.references :user, null: false, foreign_key: true, class_name: "User"
      t.references :follower, null: false, foreign_key: true, class_name: "User"

      t.timestamps
    end
  end
end
