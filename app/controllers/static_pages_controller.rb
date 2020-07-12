class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @ticket = current_user.tickets.upcomming.first
      @tickets = current_user.tickets.solved
      gon.map_data = current_user.prefecture_data
    end
  end

  def about
  end

  def tos
  end
end
