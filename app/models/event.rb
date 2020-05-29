class Event < ApplicationRecord
  scope :done, -> { where(done: true).order(date: "DESC") }
  scope :upcomming, -> { where('date >= ?', Date.current).order(date: "ASC") }
  scope :unsolved, -> { where('date < ? AND done = ?', Date.current, false).order(date: "DESC") }
  scope :release, -> { where('public = ?', true) }
  belongs_to :user
  has_many_attached :images
  has_many :likes, dependent: :destroy
  has_many :like_users, through: :likes, source: :user

  def like(user)
    likes.create(user_id: user.id)
  end

  def unlike(user)
    likes.find_by(user_id: user.id).destroy
  end

  def like?(user)
    like_users.include?(user)
  end
end
