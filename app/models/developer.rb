class Developer < ApplicationRecord
  has_many :jobs
  has_many :feedbacks

  belongs_to :user

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end