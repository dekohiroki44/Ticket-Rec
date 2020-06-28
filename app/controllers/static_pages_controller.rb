class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @ticket = current_user.tickets.upcomming.first
      @tickets = current_user.tickets.solved
      prefectures = ["都道府県"]
      current_user.tickets.done.each do |ticket|
        prefectures << ticket.prefecture
      end
      gon.prefectures = prefectures.group_by(&:itself).map { |key, value| [key, value.count] }
      gon.prefectures[0][1] = "回数"
    end
  end

  def about
  end

  def tos
  end
end
