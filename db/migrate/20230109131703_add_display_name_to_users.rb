class AddDisplayNameToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :display_name, :string, null: false, default: ''

    User.all.each do |user|
      user.update(display_name: user.username)
    end
  end
end
