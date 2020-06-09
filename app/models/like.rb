class Like < ApplicationRecord
  belongs_to :user
  belongs_to :ticket
  validates :user_id, presence: true
  validates :ticket_id, presence: true
end
