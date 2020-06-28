class Ticket < ApplicationRecord
  now = DateTime.current
  scope :done, -> { where(done: true).order(date: "DESC") }
  scope :upcomming, -> { where('date >= ?', now).order(date: "ASC") }
  scope :unsolved, -> { where('date < ? AND done = ?', now, false).order(date: "DESC") }
  scope :solved, -> { where.not('date < ? AND done = ?', now, false) }
  scope :release, -> { where('public = ?', true) }
  validates :date, presence: true
  validates :public, inclusion: { in: [true, false] }
  validates :done, inclusion: { in: [true, false] }
  belongs_to :user
  has_many_attached :images
  has_many :likes, dependent: :destroy
  has_many :like_users, through: :likes, source: :user
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  def get_weather
    if date >= DateTime.current && (date - DateTime.current) < 5.day
      weather_forecast
    elsif DateTime.current > date && date > (DateTime.current - 5.day)
      weather_past
    else
      [nil, nil]
    end
  end

  def weather_forecast
    geography = Geography.find_by(name: prefecture)
    key = Rails.application.credentials.open_weather_map[:api_key]
    client = HTTPClient.new
    time_lag = (date - DateTime.current) / 3600
    i = (time_lag / 3).to_i
    url = "https://api.openweathermap.org/data/2.5/forecast"
    query = {
      "lat": geography.latitude,
      "lon": geography.longitude,
      "units": "metric",
      "APPID": key,
    }
    response = client.get(url, query)
    data = JSON.parse(response.body)
    if response.status == 200
      [data["list"][i]["weather"][0]["icon"], data["list"][i]["main"]["temp"].to_i]
    else
      [nil, nil]
    end
  end

  def weather_past
    geography = Geography.find_by(name: prefecture)
    key = Rails.application.credentials.open_weather_map[:api_key]
    client = HTTPClient.new
    url = "https://api.openweathermap.org/data/2.5/onecall/timemachine"
    query = {
      "lat": geography.latitude,
      "lon": geography.longitude,
      "dt": "#{date.to_i}",
      "units": "metric",
      "APPID": key,
    }
    response = client.get(url, query)
    data = JSON.parse(response.body)
    if response.status == 200
      [data["current"]["weather"][0]["icon"], data["current"]["temp"].to_i]
    else
      [nil, nil]
    end
  end

  def like(user)
    likes.create(user_id: user.id)
  end

  def unlike(user)
    likes.find_by(user_id: user.id).destroy
  end

  def like?(user)
    like_users.include?(user)
  end

  def create_notification_like!(current_user)
    temp = Notification.
      where(["visitor_id = ? and visited_id = ? and ticket_id = ? and action = ? ", current_user.id, user_id, id, 'like'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        ticket_id: id,
        visited_id: user_id,
        action: 'like'
      )
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  def create_notification_comment!(current_user, comment_id)
    temp_ids = Comment.
      select(:user_id).
      where(ticket_id: id).
      where.not(user_id: current_user.id).
      distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.new(
      ticket_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

  def self.search(word, date)
    if word.present? && date.present?
      Ticket.where("(upper(name) LIKE ? OR upper(performer) LIKE ?) AND date = ?", "%#{word}%".upcase, "%#{word}%".upcase, date)
    elsif word.present? && date.blank?
      Ticket.where("upper(name) LIKE ? OR upper(performer) LIKE ?", "%#{word}%".upcase, "%#{word}%".upcase)
    elsif word.blank? && date.present?
      Ticket.where("date = ?", date)
    else
      Ticket.all
    end
  end

  def start_time
    date
  end

  def previous
    user.tickets.solved.order('date desc').where('date < ?', date).first
  end

  def next
    user.tickets.solved.order('date asc').where('date > ?', date).first
  end
end
