class CreatePostVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :post_votes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.boolean :isUpvote, default: true

      t.timestamps
    end
  end
end
