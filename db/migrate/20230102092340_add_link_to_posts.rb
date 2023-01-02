class AddLinkToPosts < ActiveRecord::Migration[7.0]
  def change
    add_reference :posts, :link, foreign_key: true, null: true
  end
end
