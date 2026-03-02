class Client < ApplicationRecord
  has_secure_password

  has_many :jobs
  has_many :feedbacks

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end