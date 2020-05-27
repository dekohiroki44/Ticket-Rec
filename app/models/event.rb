class Event < ApplicationRecord
  scope :done, -> { where(done: true).order(date: "DESC") }
  scope :upcomming, -> { where('date >= ?', Date.current).order(date: "ASC") }
  scope :unsolved, -> { where('date < ? AND done = ?', Date.current, false).order(date: "DESC") }
  scope :release, -> { where('public = ?', true) }
  belongs_to :user
  has_many_attached :images
end
