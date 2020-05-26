class Event < ApplicationRecord
  default_scope -> { order(date: :asc) }
  belongs_to :user
  has_many_attached :images
end
