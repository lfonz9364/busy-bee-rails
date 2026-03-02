class Job < ApplicationRecord
  belongs_to :client
  belongs_to :developer, optional: true

  has_many :feedbacks, dependent: :destroy

  validates :title, :description, presence: true
end