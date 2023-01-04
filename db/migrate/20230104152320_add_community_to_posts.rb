class AddCommunityToPosts < ActiveRecord::Migration[7.0]
  def change
    add_reference :posts, :community, null: true, foreign_key: true
  end
end
