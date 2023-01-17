class AddScoreToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :score, :integer, default: 0
  end
end
