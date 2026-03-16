class CreateFeedbacks < ActiveRecord::Migration[7.2]
  def change
    create_table :feedbacks, id: :uuid do |t|
      t.references  :job,     type: :uuid,  null: false,  foreign_key: true
      t.references  :user,    type: :uuid,  null: false,  foreign_key: true
      
      # Feedback specific fields
      t.integer     :rating,  null: false
      t.text        :comment
      t.string      :role,    null: false # 'client' or 'developer'

      t.timestamps
    end
    add_index :feedbacks, [:job_id, :user_id], unique: true
  end
end
