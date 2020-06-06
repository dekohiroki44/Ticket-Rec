class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  require 'date'
  require 'httpclient'

  def index
    @event = current_user.feed
    @done_events = current_user.feed.done.page(params[:page]).with_attached_images.includes(:user).includes([:like_users])
    @upcomming_events = current_user.feed.upcomming.page(params[:page]).with_attached_images.includes(:user).includes([:like_users])
    @unsolved_events = current_user.feed.unsolved.page(params[:page]).with_attached_images.includes(:user).includes([:like_users])
  end

  def show
    @event = Event.find(params[:id])
    @comments = @event.comments.page(params[:page])
    @comment = Comment.new
    if @event.performer && spotify_artist_id(@event.performer)
      id = spotify_artist_id(@event.performer)
      @track_url = get_top_track(id)
      @image_url = get_artist_image(id)
      # url = "https://api.spotify.com/v1/artists/#{id}/related-artists"
      # related_artists = JSON.parse(response.body)
      # @related_artist_name0 = related_artists["artists"][0]["name"]
      # @related_artist_name1 = related_artists["artists"][1]["name"]
      # @related_artist_name2 = related_artists["artists"][2]["name"]
    end
  end

  def new
    @event = Event.new
  end

  def create
    event = current_user.events.build(event_params_create)
    if event.save
      flash[:success] = "イベントを作成しました"
      redirect_to event
    else
      render new_event_path
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    event = Event.find(params[:id])
    if params[:event][:image_ids]
      params[:event][:image_ids].each do |image_id|
        image = event.images.find(image_id)
        image.purge
      end
    end
    if event.update_attributes(event_params_update)
      flash[:success] = "イベントを編集しました"
      redirect_to event
    else
      render edit_event_path
    end
  end

  def destroy
    event = Event.find(params[:id])
    event.destroy
    flash[:success] = "イベントを削除しました"
    redirect_to events_url
  end

  private

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

  def event_params_create
    params[:event][:date].to_date < Date.current ? done = true : done = false
    params.
      require(:event).
      permit(:name, :content, :date, :place, :prefecture, :price, :performer, :public, images: []).
      merge(done: done)
  end

  def event_params_update
    params.
      require(:event).
      permit(:name, :content, :date, :place, :prefecture, :price, :performer, :public, :done, images: [])
  end
end
