class AddScoreToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :score, :integer, default: 0
  end
end
