class JobApplication < ApplicationRecord
  belongs_to :job
  belongs_to :developer

  validates :status,  inclusion: { in: %w[pending accepted declined auto_declined] }
  validates :developer_id, uniqueness: { scope: :job_id }

  scope :pending, -> { where(status: "pending") }

  def pending?
    status == "pending"
  end

  def reviewable_by_client?(user)
    user&.client == job.client
  end

  def auto_decline_deadline
    5.business_days.after(created_at)
  end

  def expired?
    pending? && Time.current > auto_decline_deadline
  end
end