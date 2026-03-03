class Developer < ApplicationRecord
  belongs_to :user

  # Jobs this developer has been hired for
  has_many :jobs, dependent: :nullify

  # Feedbacks this developer has received from clients
  has_many :feedbacks,
           -> { where(role:'client')}, # only client-written reviews 
           through: :jobs, 
           source: :feedbacks

  # Delegate user attributes to avoid redundant calls (e.g., developer.name instead of developer.user.name)
  delegate :name,
           :email,
           :abn,
           to: :user

  validates :skillset,  presence: true, allow_blank: false
end