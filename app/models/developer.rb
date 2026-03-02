class Developer < ApplicationRecord
  has_many :jobs
  has_many :feedbacks

  belongs_to :user
end