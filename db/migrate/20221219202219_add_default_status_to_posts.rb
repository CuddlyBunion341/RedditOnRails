class AddDefaultStatusToPosts < ActiveRecord::Migration[7.0]
  def change
    change_column_default :posts, :status, "public"
  end
end
