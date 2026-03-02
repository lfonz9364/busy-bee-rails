class CreateDevelopers < ActiveRecord::Migration[7.2]
  def change
    create_table :developers, id: :uuid do |t|
      t.references  :user,  type: :uuid,  null: false,  foreign_key: true

      # Developers specific fields
      t.string      :skillset
      
      t.timestamps
    end
  end
end
