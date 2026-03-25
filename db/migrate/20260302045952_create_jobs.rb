class CreateJobs < ActiveRecord::Migration[7.2]
  def change
    create_table :jobs, id: :uuid do |t|
      t.references  :client,      type: :uuid,  null: false,        foreign_key: true
      t.references  :developer,   type: :uuid,  foreign_key: true 

      # Job specific fields
      t.string      :title,       null: false
      t.text        :description, null: false
      t.integer     :reward,      null: false
      t.string      :status,      null: false,        default: 'open'
      t.datetime    :deadline,    null: false

      t.timestamps
    end
    add_index :jobs, :status
  end
end
