class CreateCommentSaves < ActiveRecord::Migration[7.0]
  def change
    create_table :comment_saves do |t|
      t.references :user, null: false, foreign_key: true
      t.references :comment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
