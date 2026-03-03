class Feedback < ApplicationRecord
  belongs_to :user # client
  belongs_to :job

  # Ensure no empty feedbacks and valid ratings
  validates :comment, presence: true
  validates :rating, 
            presence: true,
            inclusion: { in: 1..5, message: "must be between 1 and 5" }

   validates :role,
            presence: true,
            inclusion: { in: %w[client developer] }

  # Helpers to easily access associated developer and client through job
  def developer
    job.developer
  end

  def client
    job.client
  end
end