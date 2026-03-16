class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name,                 null: false
      t.string :email,                null: false
      t.string :address,              null: false
      t.string :suburb,               null: false
      t.integer :postcode, limit: 4,  null: false
      t.string :country,              null: false
      t.string :contact_person,       null: false
      t.string :password_digest,      null: false
      t.string :abn,                  null: false

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
