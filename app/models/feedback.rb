class Feedback < ApplicationRecord
  belongs_to :client
  belongs_to :developer
  belongs_to :job

  validates :body, presence: true
  validates :rating, 
            numericality: { only_integer: true, in: 1..5 }, 
            allow_nil: true
end