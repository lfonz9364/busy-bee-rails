class AddRolesToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :role, :string, null: false, default: "-"
    add_index :users, :role
  end
end
