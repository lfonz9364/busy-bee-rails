class AddArchiveFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :active, :boolean, default: true, null: false
    add_column :users, :deleted_at, :datetime
    add_column :users, :archived_label, :string
  end
end
