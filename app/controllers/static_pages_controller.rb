class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @event = current_user.events.upcomming.first
      if @event.performer.present? && spotify_artist_id(@event.performer)
        id = spotify_artist_id(@event.performer)
        @track_url = get_top_track(id)
        @image_url = get_artist_image(id)
      end
      prefectures = ["都道府県"]
      current_user.events.done.each do |event|
        prefectures << event.prefecture
      end
      gon.prefectures = prefectures.group_by(&:itself).map { |key, value| [key, value.count] }
      gon.prefectures[0][1] = "回数"

    end
  end

  def about
  end
end
