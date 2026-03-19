class CreateJobApplications < ActiveRecord::Migration[7.2]
  def change
    create_table :job_applications, id: :uuid do |t|
      t.references :job, null: false, type: :uuid, foreign_key: true
      t.references :developer, null: false, type: :uuid, foreign_key: true

      t.string :status, null: false, default: "pending"
      t.text :message
      t.datetime :reviewed_at

      t.timestamps
    end

    add_index :job_applications, [:job_id, :developer_id], unique: true
    add_index :job_applications, :status
  end
end 