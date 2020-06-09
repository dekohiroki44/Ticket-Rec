class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :ticket
  validates :content, presence: true
  has_many :notifications, dependent: :destroy
end
