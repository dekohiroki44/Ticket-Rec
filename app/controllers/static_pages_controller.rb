class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @event = current_user.events.upcomming.first
      prefectures = ["都道府県"]
      current_user.events.done.each do |event|
        prefectures << event.prefecture
      end
      gon.prefectures = prefectures.group_by(&:itself).map { |key, value| [key, value.count] }
      gon.prefectures[0][1] = "回数"
      @image_url = @event.spotify[0]
      @track_url = @event.spotify[1]
    end
  end

  def about
  end
end
