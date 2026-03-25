class Developer < ApplicationRecord
  belongs_to :user


  has_many :jobs,             dependent: :nullify
  has_many :job_applications, dependent: :destroy
  has_many :applied_jobs,     through: :job_applications, source: :job

  has_many :received_feedbacks,
           -> { where(role:'client')}, # only client-written reviews 
           through: :jobs, 
           source: :feedbacks

  delegate :name,
           :email,
           :abn,
           to: :user

  validates :skillset,  presence: true, allow_blank: false

  validate :user_is_not_already_a_client

  after_create :assign_user_role

  def average_rating
    return 0.0 if received_feedbacks.empty?

    received_feedbacks.average(:rating).to_f.round(2)
  end

  def reviews_count
    received_feedbacks.count
  end

  def star_rating
    return "No ratings yet" if reviews_count.zero?
    "★" * average_rating.round + "☆" * (5 - average_rating.round)
  end

  def pending_job_applications
    job_applications
    .includes(job: { client: :user })
    .where(status: "pending")
    .order(created_at: :desc)
  end

  def declined_job_applications
    job_applications
    .includes(job: { client: :user })
    .where(status: ["declined", "auto_declined"])
    .order(updated_at: :desc)
  end

  def in_progress_jobs
    Job.includes(client: :user)
       .where(developer: self, status: "in_progress")
       .order(updated_at: :desc)
  end

  def completed_jobs
    Job.includes(client: :user)
       .where(developer: self, status: "completed")
       .order(updated_at: :desc)
  end

  private

  def assign_user_role
    user.update_column(:role, "developer")
  end

  def user_is_not_already_a_client
    return unless user&.client.present?

    errors.add(:user, "is already registered as a client")
  end
end