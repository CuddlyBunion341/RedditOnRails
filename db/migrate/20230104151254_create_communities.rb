class CreateCommunities < ActiveRecord::Migration[7.0]
  def change
    create_table :communities do |t|
      t.string :name
      t.string :shortname
      t.text :description
      t.references :owner, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
