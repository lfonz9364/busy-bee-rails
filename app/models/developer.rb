class Developer < ApplicationRecord
  belongs_to :user

  # Jobs this developer has been hired for
  has_many :jobs, dependent: :nullify

  # Feedbacks this developer has received from clients
  has_many :received_feedbacks,
           -> { where(role:'client')}, # only client-written reviews 
           through: :jobs, 
           source: :feedbacks

  # Delegate user attributes to avoid redundant calls (e.g., developer.name instead of developer.user.name)
  delegate :name,
           :email,
           :abn,
           to: :user

  validates :skillset,  presence: true, allow_blank: false

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
end