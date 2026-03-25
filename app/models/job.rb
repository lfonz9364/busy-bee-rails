class Job < ApplicationRecord
  belongs_to :client
  belongs_to :developer, optional: true

  has_many :feedbacks,            dependent: :destroy
  has_many :job_applications,     dependent: :destroy
  has_many :applicant_developers, through: :job_applications, source: :developer  

  validates :title, 
            :description,
            :reward,
            :status,
            :deadline, 
            presence: true
  
  validates :status, 
            inclusion: { in: ['open', 'in_progress', 'completed', 'cancelled'] }

  def taken?
    developer.present?
  end

  def owned_by_client?(user)
    user&.client.present? && client == user.client
  end

  def editable_by_client?(user)
    return false unless user&.client.present?

    client == user.client && !taken?
  end

  def deletable_by_client?(user)
    editable_by_client?(user)
  end

  def visible_to?(user)
    user.present?
  end

  def open_for_applications?
    status == "open" && !taken?
  end

  def completable_by_client?(user)
    user&.client.present? &&
    client == user.client &&
    status == 'in_progress'
  end

  def completed?
    status == "completed"
  end

  def mark_completed!
    update!(status: "completed")
  end

  def feedback_allowed?
    completed?
  end
end