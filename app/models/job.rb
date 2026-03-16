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

  def taken?
    developer.present?
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
end