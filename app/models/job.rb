class Job < ApplicationRecord
  belongs_to :client
  belongs_to :developer, optional: true

  has_many :feedbacks, dependent: :destroy

  # DB Constraints
  validates :title, 
            :description,
            :reward,
            :status,
            :deadline, 
            presence: true
  
  # Status must be one of: 'open', 'in_progress', 'completed', 'cancelled'
  validates :status, 
            inclusion: { in: ['open', 'in_progress', 'completed', 'cancelled'] }
end