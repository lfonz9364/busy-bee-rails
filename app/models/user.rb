class User < ActiveRecord::Base
  has_secure_password

  belongs_to :developer
  belongs_to :client

  has_many :feedbacks
  has_many :jobs, through: :feedbacks
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end