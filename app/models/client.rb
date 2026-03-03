class Client < ApplicationRecord
  belongs_to :user
  
  # Jobs this client has posted
  has_many :jobs, dependent: :destroy

  # Feedbacks this client has written for developers
  has_many :authored_feedbacks, 
           -> { where(role: 'client') },
           class_name: 'Feedback', 
           foreign_key: 'author_id', 
           primary_key: 'user_id'

  # Delegate user attributes to avoid redundant calls (e.g., client.name instead of client.user.name)
  delegate :name,
           :email,
           :abn,
           to: :user
end