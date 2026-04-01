class User < ActiveRecord::Base
  has_secure_password
  before_validation :normalise_abn
  before_validation :normalise_email


  #  Roles
  has_one :developer, dependent: :restrict_with_error
  has_one :client,    dependent: :restrict_with_error

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
            presence: true

  validates :email, uniqueness: true
  
  validates :role, inclusion: { in: %w[client developer] }

  validates :abn,
            format: { with: /\A\d{11}\z/, message: "must be 11 digits" },
            allow_blank: true

  scope :active_users, -> { where(active: true) }
  scope :archived_users, -> { where(active: false) }

  def client?
    client.present?
  end

  def developer?
    developer.present?
  end

  def generate_password_reset_token!
    update!(
      reset_password_token: SecureRandom.urlsafe_base64(32),
      reset_password_sent_at: Time.current
    )
  end

  def clear_password_reset_token!
    update!(
      reset_password_token: nil,
      reset_password_sent_at: nil
    )
  end

  def password_reset_expired?
    return true if reset_password_sent_at.blank?

    reset_password_sent_at < 2.hours.ago
  end

  def archived?
    !active?
  end

  def display_name
    archived? ? (archived_label.presence || "Archived user") : email
  end

  def completed_jobs_exist?
    client_completed = client&.jobs&.where(status: "completed")&.exists? || false
    developer_completed = developer&.jobs&.where(status: "completed")&.exists? || false

    client_completed || developer_completed
  end

  def in_progress_jobs_exist?
    active_statuses = %w[open in_progress]

    client_in_progress = client&.jobs&.where(status: active_statuses)&.exists? || false
    developer_in_progress = developer&.jobs&.where(status: active_statuses)&.exists? || false

    client_in_progress || developer_in_progress
  end

  def archive!
    transaction do
      original_email = email

      update!(
        active: false,
        deleted_at: Time.current,
        archived_label: "Archived user",
        email: archived_email_for(original_email)
      )
    end
  end

  private

  def normalise_abn
    self.abn = abn.to_s.gsub(/\D/, "")
  end

  def normalise_email
    self.email = email.to_s.downcase.strip
  end

  def archived_email_for(original_email)
    "archived_#{id}_#{original_email}"
  end
end