class AddLastOnlineToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_online, :datetime, default: Time.now

    User.all.each do |user|
      user.update(last_online: user.created_at)
    end
  end
end
