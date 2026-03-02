class Feedback < ApplicationRecord
  belongs_to :user
  belongs_to :job

  validates :comment, presence: true
  validates :rating, 
            numericality: { only_integer: true, in: 1..5 }, 
            allow_nil: true
end