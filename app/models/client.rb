class Client < ApplicationRecord
  belongs_to :user
  
  # Jobs this client has posted
  has_many :jobs, dependent: :destroy

  # Feedbacks this client has written for developers
  has_many :authored_feedbacks, 
           -> { where(role: 'client') },
           class_name: 'Feedback', 
           foreign_key: :user_id, 
           primary_key: :user_id

  # Delegate user attributes to avoid redundant calls (e.g., client.name instead of client.user.name)
  delegate :name,
           :email,
           :abn,
           to: :user

  validate :user_is_not_already_a_developer

  after_create :assign_user_role

  def open_jobs
    jobs.includes(developer: :user).where(status: "open").order(created_at: :desc)
  end


  def in_progress_jobs
    jobs.includes(developer: :user).where(status: "in_progress").order(updated_at: :desc)
  end

  def completed_jobs
    jobs.includes(developer: :user).where(status: "completed").order(updated_at: :desc)
  end

  def cancelled_jobs
    jobs.includes(developer: :user).where(status: "cancelled").order(updated_at: :desc)
  end
  
  private

  def assign_user_role
    user.update_column(:role, "client")
  end

  def user_is_not_already_a_developer
    return unless user&.developer.present?

    errors.add(:user, "is already registered as a developer")
  end
end