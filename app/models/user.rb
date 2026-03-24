class User < ActiveRecord::Base
  has_secure_password
  before_validation :normalise_abn

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
            presence: true

  validates :email, uniqueness: true
  
  validates :role, inclusion: { in: %w[client developer] }

  validates :abn,
            format: { with: /\A\d{11}\z/, message: "must be 11 digits" },
            allow_blank: true

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

  private

  def normalise_abn
    self.abn = abn.to_s.gsub(/\D/, "")
  end
end