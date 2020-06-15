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

  def spotify
    url = "https://accounts.spotify.com/api/token"
    query = { "grant_type": "client_credentials" }
    key = Rails.application.credentials.spotify[:client_base64]
    header = { "Authorization": "Basic #{key}" }
    client = HTTPClient.new
    response = client.post(url, query, header)

    if response.status == 200
      auth_params = JSON.parse(response.body)
      authenticate_token = auth_params["access_token"]
      url = 'https://api.spotify.com/v1/search'
      query = { "q": performer.split(",").first, "type": "artist", "market": "JP", "limit": 1 }
      header = { "Authorization": "Bearer #{authenticate_token}", "Accept-Language": "ja;q=1" }
      response_ja = client.get(url, query, header)
      spotify_artist_ja = JSON.parse(response_ja.body)
      header = { "Authorization": "Bearer #{authenticate_token}" }
      response_en = client.get(url, query, header)
      spotify_artist_en = JSON.parse(response_en.body)

      if response_ja.status == 200 || response_en.status == 200
        if spotify_artist_ja["artists"]["items"][0]["name"] == performer.split(",").first
          spotify_id = spotify_artist_ja["artists"]["items"][0]["id"]
          image_url = spotify_artist_ja["artists"]["items"][0]["images"][1]["url"]
        elsif spotify_artist_en["artists"]["items"][0]["name"].downcase == performer.split(",").first.downcase
          spotify_id = spotify_artist_en["artists"]["items"][0]["id"]
          image_url = spotify_artist_en["artists"]["items"][0]["images"][1]["url"]
        else
          return nil, nil
        end

        if spotify_id.present?
          url = "https://api.spotify.com/v1/artists/#{spotify_id}/top-tracks"
          query = { "market": "JP", "limit": 1 }
          response = client.get(url, query, header)

          if response.status == 200
            top_tracks = JSON.parse(response.body)
            track_url = top_tracks["tracks"].sample["preview_url"]
            return image_url, track_url
          else
            return image_url, nil
          end
        else
          return nil, nil
        end
      else

        return nil, nil
      end
    else
      return nil, nil
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
