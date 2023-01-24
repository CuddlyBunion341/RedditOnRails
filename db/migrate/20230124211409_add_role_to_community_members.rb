class AddRoleToCommunityMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :community_members, :role, :integer, default: 0
  end
end
