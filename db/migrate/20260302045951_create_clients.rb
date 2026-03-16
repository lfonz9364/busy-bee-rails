class CreateClients < ActiveRecord::Migration[7.2]
  def change
    create_table :clients, id: :uuid do |t|
      t.references  :user,  type: :uuid,  null: false,  foreign_key: true

      t.timestamps
    end
  end
end
