class Event < ApplicationRecord
  scope :done, -> { where(done: true).order(date: "DESC") }
  scope :upcomming, -> { where('date >= ?', Date.current).order(date: "ASC") }
  scope :unsolved, -> { where('date < ? AND done = ?', Date.current, false).order(date: "DESC") }
  scope :release, -> { where('public = ?', true) }
  belongs_to :user
  has_many_attached :images
  has_many :likes, dependent: :destroy
  has_many :like_users, through: :likes, source: :user
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  def authenticate_token
    url = "https://accounts.spotify.com/api/token"
    query = { "grant_type": "client_credentials" }
    key = Rails.application.credentials.spotify[:client_base64]
    header = { "Authorization": "Basic #{key}" }
    client = HTTPClient.new
    response = client.post(url, query, header)
    auth_params = JSON.parse(response.body)
    auth_params["access_token"]
  end

  def spotify_artist_id(performer)
    performer = performer.split(",").first
    url = 'https://api.spotify.com/v1/search'
    query = { "q": performer, "type": "artist", "market": "JP", "limit": 1 }
    header = { "Authorization": "Bearer #{authenticate_token}" }
    client = HTTPClient.new
    response = client.get(url, query, header)
    spotify_artist_en = JSON.parse(response.body)
    header = { "Authorization": "Bearer #{authenticate_token}", "Accept-Language": "ja;q=1" }
    client = HTTPClient.new
    response = client.get(url, query, header)
    spotify_artist_ja = JSON.parse(response.body)
    if spotify_artist_en["artists"]["items"].present? && spotify_artist_en["artists"]["items"][0]["name"].downcase == performer.downcase
      spotify_artist_en["artists"]["items"][0]["id"]
    elsif spotify_artist_ja["artists"]["items"].present? && spotify_artist_ja["artists"]["items"][0]["name"] == performer
      spotify_artist_ja["artists"]["items"][0]["id"]
    end
  end

  def get_top_track(id)
    url = "https://api.spotify.com/v1/artists/#{id}/top-tracks"
    query = { "market": "JP" }
    header = { "Authorization": "Bearer #{authenticate_token}" }
    client = HTTPClient.new
    response = client.get(url, query, header)
    top_tracks = JSON.parse(response.body)
    top_tracks["tracks"].sample["preview_url"]
  end

  def get_artist_image(id)
    url = "https://api.spotify.com/v1/artists/#{id}"
    query = { "market": "JP" }
    header = { "Authorization": "Bearer #{authenticate_token}" }
    client = HTTPClient.new
    response = client.get(url, query, header)
    artist_info = JSON.parse(response.body)
    artist_info["images"][1]["url"]
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
      where(["visitor_id = ? and visited_id = ? and event_id = ? and action = ? ", current_user.id, user_id, id, 'like'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        event_id: id,
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
      where(event_id: id).
      where.not(user_id: current_user.id).
      distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.new(
      event_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
end
