class User < ActiveRecord::Base
  has_secure_password

  #  Roles
  has_one :developer, dependent: :destroy
  has_one :client,    dependent: :destroy

  # Feedbacks this user has written (as a client) or received (as a developer)
  has_many  :authored_feedbacks,
            class_name: 'Feedback',
            dependent: :destroy
  
  # Validations mirroring DB constraints
  validates :name,
            :email, 
            :address,
            :suburb, 
            :state,
            :postcode,
            :country, 
            :contact_person, 
            :abn,             
            presence: true

  validates :email, uniqueness: true
  
  validates :role, inclusion: { in: %w[client developer] }, allow_nil: false
end